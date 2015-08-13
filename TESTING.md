This cookbook includes support for running tests via Test Kitchen. This has some requirements.

1. You must be using the Git repository, rather than the downloaded cookbook from the Supermarket Site.
2. You must have Vagrant installed.
3. You must have a "sane" Ruby 1.9.3+ environment.

Once the above requirements are met, install the additional requirements:

Install test kitchen and other testing bems via bundler
    bundle install

Once the above are installed, you should be able to run Test Kitchen:

    kitchen list
    kitchen test
