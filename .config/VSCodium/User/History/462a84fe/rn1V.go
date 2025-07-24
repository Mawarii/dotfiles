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

	"github.com/go-logr/logr"
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

	msDeployment := r.findMetricsServerDeployment(ctx, req, log)

	var metricsServer v1beta1.MetricsServer
	if err := r.Get(ctx, req.NamespacedName, &metricsServer); err != nil {
		log.Info("unable to fetch Metrics Server resource", "name", req.Name)

		// soll hier einfach der nil check geskipped werden?
		if err := r.Delete(ctx, msDeployment); err != nil {
			log.Info("failed to delete deployment", "name", msDeployment.Name, "namespace", msDeployment.Namespace)
			return ctrl.Result{}, client.IgnoreNotFound(err)
		}

		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	log.Info("Reconciling Metrics Server image", "Name", metricsServer.Name, "Image", metricsServer.Spec.Image)

	if len(metricsServer.Status.Id) == 0 {
		id := util.GenerateRandomID(8)
		metricsServer.Status.Id = id
	}

	if msDeployment == nil {
		msDeployment = r.generateMetricsServerDeployment(metricsServer)
	}

	if err := r.Create(ctx, msDeployment); err != nil {
		log.Error(err, "failed to apply deployment")
	}

	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *MetricsServerReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&klopsv1beta1.MetricsServer{}).
		Owns(&v1apps.Deployment{}).
		Complete(r)
}

func (r *MetricsServerReconciler) findMetricsServerDeployment(ctx context.Context, req ctrl.Request, log logr.Logger) *v1apps.Deployment {
	// get managed deployments
	deploymentList := v1apps.DeploymentList{}
	if err := r.List(ctx, &deploymentList); err != nil {
		log.Info("can't list deployments")
		return nil
	}

	// loop over elements to check if any deployments are there
	for _, e := range deploymentList.Items {
		if e.Name == req.Name && e.Namespace == req.Namespace {
			return &e
		}
	}

	return nil
}

func (r *MetricsServerReconciler) generateMetricsServerDeployment(ms klopsv1beta1.MetricsServer) *v1apps.Deployment {
	metadata := v1meta.ObjectMeta{
		Name:      ms.Name,
		Namespace: ms.Namespace,
	}

	labels := map[string]string{
		"operated-by": "klops",
		"app":         "metrics-server",
		"id":          ms.Status.Id,
	}

	containers := []v1.Container{
		{
			Name:  "metrics-server",
			Image: ms.Spec.Image,
		},
	}

	deployment := &v1apps.Deployment{
		ObjectMeta: metadata,
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

	return deployment
}
