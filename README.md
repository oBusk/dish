# oBusk/dish

> 🍽🐚 Dns In SHell. A collection of scripts for evaluating DNS resolvers

## Usage

### [run-all.sh](./run-all.sh)

> Evaluate all DNS-es specified in [`resolvers.txt`](./resolvers.txt) using all tests

```bash
$ ./run-all.sh
# Resolver IP; Remote IP; Location of Remote IP; Number of jumps to Remote IP; Pretransfer Time
81.26.228.3; 2.22.238.30; Stockholm, SE; 8; 9.7ms
# ...
216.146.35.35; 23.37.238.34; Frankfurt am Main, DE; 15; 50.8ms
```

### [run-multiple.sh](./run-multiple.sh)

> Evaluate all DNS-es provided in standard input using all tests

```bash
$ ./run-multiple.sh <resolvers.txt
# Resolver IP; Remote IP; Location of Remote IP; Number of jumps to Remote IP; Pretransfer Time
81.26.228.3; 2.22.238.30; Stockholm, SE; 8; 9.7ms
# ...
216.146.35.35; 23.37.238.34; Frankfurt am Main, DE; 15; 50.8ms
```

### [url-test.sh](./url-test.sh)

> Evaluate what CDN Edge node the DNS (_resolver ip_) resolves _url_ to.

Takes a _target url_, resolves the **remote ip** using _resolver ip_, finds
the location of the **remote ip** and the distance (number of hops to it),
and also measures the **pretransfer-time** to it.

The idea of this test is to evaluate the use of _resolver ip_ when connecting
to distributed [content delivery networks](https://en.wikipedia.org/wiki/Content_delivery_network)

```bash
$ # ./url-test.sh <resolver ip> <target url>
$ ./url-test.sh 8.8.8.8 https://www.akamai.com/us/en/multimedia/images/logo/akamai-logo.png
# Resolver IP; Remote IP; Location of Remote IP; Number of jumps to Remote IP; Pretransfer Time
8.8.8.8; 2.22.3.60; Stockholm, SE; 10; 13.0ms
```

## License

ISC © Oscar Busk
