hcloud_token             = "RtYQHLFbld9IyTZQkjzJSGAt7FMJkQL4RE2cYXyoKag0Vqz2MWw0x7utdL7CqhCv"

# the crio version wanted
# currently still using the suse mirrors so only <= 1.28 is supported
crio_version = "1.28"

# kubernetes version
kube_version = "1.30"

worker = {
  "w-1" = {
    name = "w-1"
    type = "cax21"
  },
  "w-2" = {
    name = "w-2"
    type = "cax21"
  },
  "w-3" = {
    name = "w-3"
    type = "cax21"
  }
}

control-plane = {
  "cp1" = {
    name = "cp-1"
    type = "cx22"
  },
  "cp2" = {
    name = "cp-2"
    type = "cx22"
  },
  "cp3" = {
    name = "cp-3"
    type = "cx22"
  }
}