soc-container-images - Container images for SUSE OpenStack Cloud
----------------------------------------------------------------

This repository contains kiwi_ definitions to build containers for
`SUSE OpenStack Cloud`_.
The containers are built in the `Open Build Service`_.

Generating the .kiwi files from templates
=========================================

We want to build containers based on different base containers (eg. for
openSUSE or SLE). To accomplish that, we use Jinja2 templates and
YAML based (.yml) files which contain variables to fill the templates.

The tool to process the single template (usually .kiwi.j2) and the
variable files(s) (usually .yml) is `j2gen`_

`j2gen` allows multiple variable files which are combined together (for
dict/hash like data structures, the structures are merged where the last
occurance wins).
So we can have a chain of variable files like:

- common/global.yml (used for *all* containers)
- $image/common.yml (used for all $image containers)
- $image/$distro.yml (used for the $distro specific container)
- $image/$image.kiwi.j2 (the template to build $image for all distros)

The .kiwi output file (eg. for a memcached SLE15SP1 image) can be generated
from the above files with::

  j2gen generate --output memcached-image.kiwi \
    memcached-image/memcached-image.kiwi.j2 \
    common/global.yml \
    memcached-image/common.yml \
    memcached-image/SLE_15_SP1.yml

The generated file is then `memcached-image.kiwi`.

OpenBuildService integration
============================

The OpenBuildService (OBS) has the concept of `source services`_ which can be
used to automate most of the tasks needed.

Getting the code from git
+++++++++++++++++++++++++

To get the code from this repository (git) into an OBS package, there is the
`tar_scm`_ source service. This service will download and extract the files
needed to generate a .kiwi file for building a container

Generating a .kiwi file with j2gen
++++++++++++++++++++++++++++++++++

Instead of manually running `j2gen` with all the needed parameters, there is a
`j2gen source service`_ available. This service will render the kiwi.j2 template
into a .kiwi file.

Contributing and testing
========================

Contributions are welcome. Please open pull requests (PR) against
https://github.com/SUSE-Cloud/soc-container-images/ .

Running j2gen and validate with kiwi
++++++++++++++++++++++++++++++++++++

There is a script to run `j2gen` and `kiwi` for validation. To execute
this locally, do::

  tox -evalidate


.. _kiwi: https://osinside.github.io/kiwi/index.html
.. _`SUSE OpenStack Cloud`: https://www.suse.com/products/suse-openstack-cloud/
.. _`Open Build Service`: https://openbuildservice.org/
.. _`j2gen`: https://pypi.org/project/j2gen/
.. _`source services`: https://openbuildservice.org/help/manuals/obs-user-guide/cha.obs.source_service.html
.. _`tar_scm`: https://github.com/openSUSE/obs-service-tar_scm
.. _`j2gen source service`: https://github.com/toabctl/obs-service-j2gen
