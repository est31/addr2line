#!/usr/bin/env bash

set -ex

case "$GIMLI_JOB" in
    "build")
        cargo build $GIMLI_PROFILE --features "$GIMLI_FEATURES"
        ;;

    "test")
        cargo build $GIMLI_PROFILE --features "$GIMLI_FEATURES"
        cargo test $GIMLI_PROFILE --features "$GIMLI_FEATURES"
        ;;

    "doc")
        cargo doc
        ;;

    "bench")
        cargo bench
        ;;

    "coverage")
        bash <(curl "https://raw.githubusercontent.com/xd009642/tarpaulin/master/travis-install.sh");
        cargo tarpaulin --verbose --no-count --ciserver travis-ci --coveralls "$TRAVIS_JOB_ID";
        ;;

    "cross")
        rustup target add $TARGET
        cargo install cross --force
        cross test --target $TARGET $GIMLI_PROFILE --features "$GIMLI_FEATURES"
        ;;

    *)
        echo "Error! Unknown \$GIMLI_JOB: $GIMLI_JOB"
        exit 1
esac
