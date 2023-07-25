{ ocproxy-src, ocproxy }: ocproxy.overrideAttrs ({ patches ? [ ], ... }: {
  src = ocproxy-src;
  patches = patches ++ [
    ## https://github.com/cernekee/ocproxy/pull/21
    ./0001-add-u-and-g-options-for-mapped-u-g-id.patch
    ## https://github.com/cernekee/ocproxy/pull/22
    ./0001-deactivate-nscd-in-container.patch
  ];
})
