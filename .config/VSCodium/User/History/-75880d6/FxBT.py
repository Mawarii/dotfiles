import os
import subprocess
import yaml


def read_yaml_file(filename):
    with open(filename, 'r') as stream:
        try:
            data = yaml.safe_load(stream)
            return data
        except yaml.YAMLError as exc:
            print(exc)


def get_env_variable(var_name):
    if debugmode:
        return ""
    value = os.getenv(var_name)
    if not value:
        raise SystemExit(f"Environment variable {var_name} is not set.")
    return value


def run_command(command):
    command_str = ' '.join(command)
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"Executed command: {command_str}\nCommand executed successfully. Output:\n{result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Executed command: {command_str}\nCommand failed. Output:\n{e.stdout}\nError:\n{e.stderr}")


def run_skopeo_copy(src, dest, src_credentials=None, dest_credentials=None):
    command = ["skopeo", "copy", "--src-tls-verify=false", "--dest-tls-verify=false"]
    if src_credentials:
        command.extend(["--src-creds", src_credentials])
    if dest_credentials:
        command.extend(["--dest-creds", dest_credentials])
    command.extend([src, dest])
    run_command(command)


def process_yaml(filename, src_credentials=None, dest_credentials=None):
    if debugmode:
        print("start in debugmode")
    data = read_yaml_file(filename)

    for obj in data:
        src_image = obj.get('srcImage')
        src_tag = obj.get('srcTag')
        dest_image = obj.get('destImage')
        dest_tag = obj.get('destTag')

        if "gitlab" not in src_image:
            src = f"docker://harbor.dev.publicplan.cloud/docker_proxy/{src_image}:{src_tag}"
        else:
            src = f"docker://{src_image}:{src_tag}"
        dest = f"docker://{dest_image}:{dest_tag}"

        if debugmode:
            print(f"{src_image}:{src_tag} -> {dest_image}:{dest_tag}")
        else:
            run_skopeo_copy(src, dest, src_credentials, dest_credentials)


debugmode = os.environ.get('SYNC_DEBUGMODE') == "TRUE"
pp_username = get_env_variable('CRED_GITLAB_PUBLICPLAN_USERNAME')
pp_password = get_env_variable('CRED_GITLAB_PUBLICPLAN_PASSWORD')
krz_username = get_env_variable('CRED_GITLAB_KRZ_K8S_USERNAME')
krz_password = get_env_variable('CRED_GITLAB_KRZ_K8S_PASSWORD')

pp_credentials = f"{pp_username}:{pp_password}" if pp_username and pp_password else None
krz_credentials = f"{krz_username}:{krz_password}" if krz_username and krz_password else None
