# Container registry

Images are stored in Harbor at `harbor.adnovumlabs.com/aidemo/devsecops-demo`.

- CI (`.github/workflows/build.yml`) logs in with the `HARBOR_USERNAME` / `HARBOR_PASSWORD` secrets and pushes `:<git sha>`.
- The lab overlay (`k8s/overlays/lab/kustomization.yaml`) pins the deployed image by digest:

  ```yaml
  images:
    - name: devsecops-demo
      newName: harbor.adnovumlabs.com/aidemo/devsecops-demo
      digest: sha256:<digest>
  ```

  Use `digest`, not `newTag`; a tag cannot be combined with a digest.
- The cluster pulls with the `harbor-pull` image pull secret.
