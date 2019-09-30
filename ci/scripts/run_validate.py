#!/usr/bin/python3
# Copyright (c) 2019 SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import glob
import os
import subprocess
import sys
import tempfile


def _run_kiwi(kiwi_file):
    """Try to run kiwi"""
    cmd = ['kiwi-ng-3', 'image', 'info', '--description', kiwi_file]
    try:
        subprocess.check_output(' '.join(cmd), shell=True)
    except subprocess.CalledProcessError as e:
        # stdout/stderr were added in python3.5
        if hasattr(e, 'stdout') and e.stdout:
            print(e.stdout.decode('utf-8'))
        if hasattr(e, 'stderr') and e.stderr:
            print(e.stderr.decode('utf-8'))
        sys.exit('Failed to call "{}" (return code: {})'
                 .format(e.cmd, e.returncode))


def _run_j2gen(template, vars_chain, outfile):
    """Try to run j2gen"""
    cmd = ['j2gen', 'generate', '-o', outfile, template] + vars_chain
    try:
        subprocess.check_output(' '.join(cmd), shell=True)
    except subprocess.CalledProcessError as e:
        # stdout/stderr were added in python3.5
        if hasattr(e, 'stdout') and e.stdout:
            print(e.stdout)
        if hasattr(e, 'stderr') and e.stderr:
            print(e.stderr)
        sys.exit('Failed to call "{}" (return code: {})'
                 .format(e.cmd, e.returncode))
    else:
        # print the j2gen rendered output
        with open(outfile, 'r') as of:
            print(of.read())


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit('No base directory given as argument')
    base_dir = sys.argv[1]

    # expect a common/global.yml variable file
    vars_global = os.path.join(base_dir, 'common', 'global.yml')
    if not os.path.exists(vars_global):
        sys.exit('Global vars file {} not found'.format(vars_global))

    kiwi_templates = glob.glob(os.path.join(base_dir, '*/*.kiwi.j2'))
    for kt in kiwi_templates:
        # the variables files in the correct order
        vars_chain = [vars_global]
        # kiwi.j2 base directory
        kt_dirname = os.path.dirname(kt)
        # common vars file per template is optional
        vars_kt_common = os.path.join(kt_dirname, 'common.yml')
        if os.path.exists(vars_kt_common):
            vars_chain.append(vars_kt_common)
        # assume that every .yml file (except common.yml) in the kw_basedir is
        # a flavor
        kt_flavors = glob.glob(os.path.join(kt_dirname, '*.yml'))
        for kt_flavor in kt_flavors:
            if kt_flavor.endswith('common.yml'):
                continue
            print('# Template {} wit flavor {}'.format(kt, kt_flavor))
            # write the j2gen output to a temp file and validate it with kiwi
            with tempfile.TemporaryDirectory() as kiwi_dir:
                kiwi_file = os.path.join(kiwi_dir, 'my.kiwi')
                _run_j2gen(kt, vars_chain + [kt_flavor], kiwi_file)
                _run_kiwi(kiwi_dir)

    sys.exit(0)
