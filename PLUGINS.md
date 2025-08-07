# Plugins

VeeCode DevPortal supports a variety of dynamic plugins to extend its functionality. Some of these plugins have been bundled with the released DevPortal image, while others can be downloded and installed in runtime (during DevPortal initialization).

## Bundled Plugins' settings

We try to provide good defaults for the bundled plugins, but you can always override them in your `values.yaml` file used in Helm setup.

## Using a local NPM registry

When developing plugins, you might want to use a local NPM registry to speed up the development process.

You can start a local NPM registry using [Verdaccio](https://verdaccio.org/):

```sh
verdaccio -l 0.0.0.0:4873
```

Our chart mounts the `.npmrc` file a secret (if it exists):

```
kubectl create secret generic veecode-devportal-dynamic-plugins-npmrc \
  "--from-literal=.npmrc=registry=http://host.k3d.internal:4873/"
```

Note: you can use `host.k3d.internal` or the a IP address to reach local Verdaccio instance.

Deploy DevPortal locally:

```bash
helm upgrade --install veecode-devportal ./veecode-devportal-chart \
    -f examples/vkdr-minimal.yaml
```
