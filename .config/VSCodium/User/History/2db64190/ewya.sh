#!/usr/bin/env bash
# Install Formsflow.ai at BITBW at stage projectspace

source "install.cfg"

echo -n "Install/Upgrade formsflow.ai? (y/n): "
read -r ANSWER

if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then  
  helm repo add "$REPO_NAME" "$REPO_URL"
  if [[ $? != 0 ]]; then
    echo "Aborting..."
    exit 1
  fi
  helm repo update "$REPO_NAME"
  echo "These charts will be installed:"
  helm search repo "$REPO_NAME" --version "$VERSION"

  kubectl apply -n "$NAMESPACE" -f "resources/$IDM_CONFIG"
  kubectl apply -n "$NAMESPACE" -f "resources/$KRB5_CONFIG"
  kubectl apply -n "$NAMESPACE" -f "resources/$URL_CONFIG"
  kubectl apply -n "$NAMESPACE" -f "resources/$MIGRATION_CONFIG"
  kubectl apply -n "$NAMESPACE" -f "resources/$MICRO_CONTAINER"
  kubectl apply -n "$NAMESPACE" -f "resources/$KEYTAB_SECRET"

  #helm upgrade --install formsflow-mongodb bitnami/mongodb -n "$NAMESPACE" -f resources/mongodb-forms-flow-ai-values.yaml --version="14.0.9"
  helm upgrade --install formsflow-postgresql-idm bitnami/postgresql -n "$NAMESPACE" -f resources/postgresql-forms-flow-idm-values.yaml --version="13.1.2"
  helm upgrade --install formsflow-postgresql-ai bitnami/postgresql -n "$NAMESPACE" -f resources/postgresql-forms-flow-ai-values.yaml --version="13.1.2"

  # Loop to install all charts
  for CHART in "${CHARTS[@]}"
  do
    # Install chart(s) in defined namespace
    helm upgrade --install "$CHART" "$REPO_NAME/$CHART" --namespace "$NAMESPACE" --version="$VERSION" -f "$CHART-values.yaml"
  done

  kubectl apply -n "$NAMESPACE" -f "resources/$ROUTEN"
fi

echo -n "Install/Upgrade Backup for DBs? (y/n): "
read -r ANSWER

if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then 

  kubectl apply -n "$NAMESPACE" -k "backup-resources/"

fi
