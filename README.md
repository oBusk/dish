# oBusk/dish

> 🍽 🐚 A collection of scripts for evaluating DNS resolvers

## Usage

### [httptest.sh](./httptest.sh)

Resolves an IP to a _target domain_, using _resolver ip_, then checks how far
away that IP is from your current location.

```bash
$ # bash httptest.sh <resolver ip> <target domain>
$ bash httptest.sh 8.8.8.8 assets.adobedtm.com
```

## License

ISC © Oscar Busk
