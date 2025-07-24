#!/usr/bin/env bash
# Uninstall Formsflow.ai at BITBW at stage projectspace

source "install.cfg"

echo -n "Uninstall formsflow.ai? (y/n):"
read -r ANSWER

if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then  
  echo "These charts will be uninstalled:"
  helm search repo "$REPO_NAME" --version "$VERSION"

  kubectl delete -n "$NAMESPACE" -f "resources/$IDM_CONFIG"
  kubectl delete -n "$NAMESPACE" -f "resources/$KRB5_CONFIG"
  kubectl delete -n "$NAMESPACE" -f "resources/$URL_CONFIG"
  kubectl delete -n "$NAMESPACE" -f "resources/$MICRO_CONTAINER"
  kubectl delete -n "$NAMESPACE" -f "resources/$MIGRATION_CONFIG"  
  kubectl delete -n "$NAMESPACE" -f "resources/$ROUTEN"
  kubectl delete -n "$NAMESPACE" -f "resources/$KEYTAB_SECRET"

  # Loop to install all charts
  for CHART in "${CHARTS[@]}"
  do
    # Install chart(s) in defined namespace
    helm delete -n "$NAMESPACE" "$CHART"
  done

  #helm delete -n "$NAMESPACE" formsflow-mongodb
  helm delete -n "$NAMESPACE" formsflow-postgresql-idm
  helm delete -n "$NAMESPACE" formsflow-postgresql-ai


  echo -n "Delete pvcs of all Databases? (y/n):"
  read -r ANSWER

  if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then  
    # kubectl delete -n "$NAMESCAPE" pvc forms-flow-ai-mongodb
    kubectl delete -n "$NAMESPACE" pvc datadir-forms-flow-ai-mongodb-0
    kubectl delete -n "$NAMESPACE" pvc data-forms-flow-postgresql-idm-0
    kubectl delete -n "$NAMESPACE" pvc data-forms-flow-postgresql-ai-0
    kubectl delete -n "$NAMESPACE" pvc redis-data-redis-exporter-0
  fi
fi

echo -n "Delete all backup CronJobs? (y/n):"
read -r ANSWER

if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then  
  kubectl delete -n "$NAMESPACE" -f "backup-resources/backup-cronjob-mongodb-forms-flow-ai.yaml"
  kubectl delete -n "$NAMESPACE" -f "backup-resources/backup-cronjob-postgresql-forms-flow-ai.yaml"
  kubectl delete -n "$NAMESPACE" -f "backup-resources/backup-cronjob-postgresql-forms-flow-idm.yaml"

  echo -n "Delete backup-pvc? (ATTENTION: All backups are lost!!!) (y/n):"
  echo -n "Are sure??? (y/n):"
  read -r ANSWER

  if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then  
    kubectl delete -n "$NAMESPACE" pvc forms-flow-backup
  fi
fi