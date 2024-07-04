
# Karist

Karist simplifies the development and deployment of manifests for Kubernetes, and falls somewhere between Kustomize and Helm.



## Installation

The recommended ways
```bash
rbenv install 3.1.0
rbenv global 3.1.0

gem install karist
karist help
```

You can also use a Docker container to run Karist.

```bash
docker run -ti --name karist ruby:alpine sh
$ gem install karist
karist help
```


## Usage/Examples


```bash
$ karist help

Commands:
  karist help [COMMAND]  # Describe available commands or one specific command
  karist init PATH       # Generates a initial project at PATH
  karist render ENV      # Render releases from environment ENV
```


## Running Tests

Tests don't require any external file or interaction. You can run tests using the following commande (test-unit):

```bash
  TESTOPTS="-v" rake test
```


## Documentation

For more information regarding the use and particularities of Karist, consult the wiki of this GitHub repository!
## License

[MIT](https://choosealicense.com/licenses/mit/)

