/*
Copyright 2024.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controller

import (
	"context"
	"fmt"

	v1apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	v1meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/log"

	"gitlab.publicplan.cloud/core/klops/api/v1beta1"
	klopsv1beta1 "gitlab.publicplan.cloud/core/klops/api/v1beta1"
	"gitlab.publicplan.cloud/core/klops/util"
)

// MetricsServerReconciler reconciles a MetricsServer object
type MetricsServerReconciler struct {
	client.Client
	Scheme    *runtime.Scheme
	Namespace string
}

//+kubebuilder:rbac:groups=klops.publicplan.de,resources=metricsservers,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=klops.publicplan.de,resources=metricsservers/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=klops.publicplan.de,resources=metricsservers/finalizers,verbs=update
//+kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;create;update;patch;delete

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
// TODO(user): Modify the Reconcile function to compare the state specified by
// the MetricsServer object against the actual cluster state, and then
// perform operations to make the cluster state reflect the state specified by
// the user.
//
// For more details, check Reconcile and its Result here:
// - https://pkg.go.dev/sigs.k8s.io/controller-runtime@v0.17.0/pkg/reconcile
func (r *MetricsServerReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log := log.FromContext(ctx)

	var metricsServer v1beta1.MetricsServer
	if err := r.Get(ctx, req.NamespacedName, &metricsServer); err != nil {
		log.Error(err, "unable to fetch Metrics Server resource")
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	log.Info("Reconciling Metricsserver Image", "Name", metricsServer.Name, "Image", metricsServer.Spec.Image)

	deployment := generateMetricsServerDeployment(r.Namespace, metricsServer.Spec)

	if err := r.Create(ctx, deployment); err != nil {
		log.Error(err, "failed to apply deployment")
	}

	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *MetricsServerReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&klopsv1beta1.MetricsServer{}).
		Complete(r)
}

func generateMetricsServerDeployment(namespace string, spec klopsv1beta1.MetricsServerSpec) *v1apps.Deployment {
	if len(spec.DeploymentSuffix) == 0 {
		id := util.GenerateRandomID(6)
		spec.DeploymentSuffix = id
	}

	generatedName := fmt.Sprintf("metrics-server-%s", spec.DeploymentSuffix)

	labels := map[string]string{
		"operated-by": "klops",
		"app":         "metrics-server",
	}

	containers := []v1.Container{
		{
			Name:  "metrics-server",
			Image: spec.Image,
		},
	}

	return &v1apps.Deployment{
		ObjectMeta: v1meta.ObjectMeta{
			Name:      generatedName,
			Namespace: namespace,
		},
		Spec: v1apps.DeploymentSpec{
			Selector: &v1meta.LabelSelector{
				MatchLabels: labels,
			},
			Template: v1.PodTemplateSpec{
				ObjectMeta: v1meta.ObjectMeta{
					Labels: labels,
				},
				Spec: v1.PodSpec{
					Containers: containers,
				},
			},
		},
	}
}
