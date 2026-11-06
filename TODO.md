# Roadmap TODO

Work through phases in order, one item at a time. Numbers in brackets refer to the original review findings.

## Phase 1: Foundation (CI/CD and GitOps baseline)

### 1.1 Unblock the deploy
- [x] Create the `harbor-pull` secret in `devsecops-demo` (done manually; move to Sealed Secrets in Phase 4) [14]
- [ ] Commit and push the `kustomization.yaml` digest fix and the `application.yaml` repoURL change
- [ ] Hard-refresh and sync Argo CD, confirm the pod is healthy

### 1.2 Pipeline foundations
- [ ] Write the pushed image digest back into `k8s/overlays/lab/kustomization.yaml` (`digest:`, no `newTag`) and commit it [8]
- [ ] Build (no push) on PRs so later gates can block merges [9]
- [ ] Set job-level `permissions` for what each job does [10]
- [ ] Pin GitHub Actions by commit SHA [11]
- [ ] Drop arm64 and QEMU unless needed [12]
- [ ] Add Docker layer cache [13]
- [ ] Split `requirements-dev.txt` from runtime requirements [2]

### 1.3 Workload hardening
- [ ] Replace the base Deployment image with a neutral placeholder [15]
- [ ] Add NetworkPolicy, PodDisruptionBudget, ServiceAccount with `automountServiceAccountToken: false` [16]
- [ ] Add Pod Security Admission `restricted` labels to the namespace in Terraform [17]
- [ ] Add a `/tmp` emptyDir for the read-only root filesystem [18]
- [ ] Scope Argo CD with a dedicated `AppProject` instead of `default` [19]
- [ ] Decide whether an Ingress is needed [20]

### 1.4 Repo hygiene and docs
- [ ] README: architecture, setup, runbook [21]
- [ ] Review `application/tests/` and add a coverage gate [22]
- [ ] Dependabot or Renovate (pip, actions, Docker) [23]
- [ ] Add `.dockerignore` and `.pre-commit-config.yaml` [24]
- [ ] Pin the Dockerfile base image by digest and add a `HEALTHCHECK` [25]
- [ ] Terraform: `required_version`, decide on tracking `.terraform.lock.hcl`, remote state if beyond a lab [26]
- [ ] Put the roadmap and phase scope in `docs/` or the README (`CLAUDE.md` is gitignored) [27]
- [ ] Confirm nothing CI needs lives only in the local `.env` [28]

## Phase 2: DevSecOps security
Gitleaks, Semgrep, Checkov, Trivy, security gates and vulnerability policies.

- [ ] Gitleaks secret scan in CI and as a pre-commit hook [3]
- [ ] Semgrep SAST on `application/` [1]
- [ ] Hadolint on the Dockerfile [4]
- [ ] Checkov on Terraform and Kubernetes manifests [4]
- [ ] Trivy filesystem and dependency scan (replaces pip-audit) [2]
- [ ] Trivy image scan on the built image [5]
- [ ] Gates: fail the pipeline on HIGH/CRITICAL, block merges via required checks and branch protection
- [ ] Vulnerability policy: severity thresholds, `.trivyignore` with expiry and justification, exception process
- [ ] Upload findings as SARIF to GitHub code scanning
- [ ] Document the policy in `docs/`

## Phase 3: Software supply-chain security
Syft SBOM, Cosign signing, SLSA provenance, attestations and verification.

- [ ] Generate SBOM with Syft (SPDX or CycloneDX) per image digest [6]
- [ ] Sign images with Cosign by digest (keyless OIDC or key-based, decide) [7]
- [ ] Attach the SBOM as a Cosign attestation
- [ ] Generate SLSA provenance (slsa-github-generator) and attach it
- [ ] Attest scan results (Trivy) to the image
- [ ] Verify signature and attestations before deploy: admission policy (Kyverno or Sigstore policy-controller) in the cluster
- [ ] Store signatures and attestations in Harbor, enable Harbor signature checks
- [ ] Document the verification procedure

## Phase 4: GitOps and deployment
Staging, production, approval gates, environment promotion and deployment controls.

- [ ] Add `staging` and `production` overlays alongside `lab`
- [ ] Namespaces, quotas and Pod Security labels per environment (Terraform)
- [ ] Argo CD `AppProject`s and Applications per environment (consider ApplicationSet)
- [ ] Promotion flow: image digest moves lab, then staging, then production via PR
- [ ] Approval gates: GitHub Environments with required reviewers; manual sync for production
- [ ] Deployment controls: sync windows, RBAC, SSO, notifications
- [ ] Rollback procedure and runbook
- [ ] Environment-specific config and secrets handling

## Phase 5: Progressive delivery
Argo Rollouts, Canary, Blue-Green, Prometheus analysis and automatic rollback.

- [ ] Install Argo Rollouts (Terraform or Argo CD managed)
- [ ] Convert the Deployment to a Rollout
- [ ] Canary strategy with traffic weights and pauses
- [ ] Blue-Green strategy for comparison, with preview service
- [ ] Prometheus AnalysisTemplates (success rate, latency, error rate)
- [ ] Automatic rollback on failed analysis
- [ ] Traffic routing via ingress or service mesh (depends on the Phase 1 ingress decision)
- [ ] Expose app metrics from FastAPI (`/metrics`)
- [ ] Test with a deliberately bad release

## Phase 6: Observability and AIOps
Prometheus, Grafana, Elastic, Wazuh, PagerDuty integration and AI incident analysis.

- [ ] Prometheus stack (kube-prometheus-stack) with ServiceMonitor for the app
- [ ] Grafana dashboards: app, cluster, pipeline and rollout health
- [ ] Alert rules and Alertmanager routing
- [ ] Elastic: log shipping (Filebeat or Fluent Bit), indices, Kibana views
- [ ] Wazuh: agents or DaemonSet, rules for container and Kubernetes events
- [ ] PagerDuty integration via Alertmanager, escalation policy
- [ ] AI incident analysis: feed alerts, logs and recent deploy data to an LLM for summary and likely cause (use Claude API)
- [ ] Runbooks linked from alerts
- [ ] Define SLOs and error budgets

## Decisions
- Phase 1 scope confirmed.
- Digest write-back: automatic for lab (guard against pipeline loops); PR with approval for staging and production (Phase 4).
- `harbor-pull`: created manually; Sealed Secrets in Phase 4.
- Cosign: keyless (GitHub OIDC); revisit if Sigstore is unreachable or names can't be public.
- Traffic: ingress (Traefik) with Argo Rollouts, no service mesh (confirm).
