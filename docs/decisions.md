## Why Amazon EKS

Amazon EKS was chosen to reflect how Kubernetes is commonly operated in production AWS environments. Rather than focusing on basic container orchestration, this project emphasizes platform-level concerns such as security, scalability, and operational consistency.

EKS provides a managed control plane, reducing operational overhead while still exposing the complexity that DevOps engineers are expected to handle, including networking, IAM integration, cluster upgrades, and workload isolation. This allows the project to focus on real-world responsibilities instead of cluster bootstrapping.

Kubernetes was selected to demonstrate:

- Declarative infrastructure and application management
- Environment isolation using namespaces
- Standardized deployment patterns across environments
- Horizontal scaling and self-healing workloads

EKS-specific capabilities used in this project include:

- Native AWS IAM integration via IRSA for fine-grained permissions
- Managed node groups for controlled scaling and upgrades
- Integration with AWS load balancing and networking primitives

EKS was chosen over simpler services like Amazon ECS to showcase experience operating a production-grade Kubernetes platform, including GitOps-based deployments, security controls, and observability practices that are commonly expected of DevOps Engineers working in AWS-centric organizations.

