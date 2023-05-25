# -*- coding: utf-8 -*-
# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -- Project information -----------------------------------------------------

project = u'CMakeTest'
copyright = u'2020, CMakePP Organization'
author = u'CMakePP Organization'

# The short X.Y version
version = u'1.0.0'
# The full version, including alpha/beta/rc tags
release = u'1.0.0alpha'

# -- Path setup --------------------------------------------------------------

import os
import sys
import urllib.request
dir_path = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0,dir_path)

if not os.path.exists("make_tutorial.py"):
    make_tutorial_url = "https://raw.githubusercontent.com/NWChemEx-Project/" \
                        "DeveloperTools/master/scripts/make_tutorials.py"
    urllib.request.urlretrieve(make_tutorial_url, "make_tutorials.py")

from make_tutorials import make_tutorials
import cminx

src_dir  = os.path.abspath(os.path.dirname(__file__))
doc_path = os.path.dirname(dir_path)
root_path = os.path.dirname(doc_path)
build_path = os.path.join(doc_path, "build")

########################################
#  Run CMinx on our CMake source code  #
########################################

cminx_out_dir = os.path.join(src_dir, "developer", "cmake_test")
cminx_in_dir = os.path.join(root_path, "cmake", "cmake_test")
#args = ["-p", "cmake_test", "-r", "-o", cminx_out_dir, cminx_in_dir]
args = ["-s", "config.yml", "-r", cminx_in_dir]
cminx.main(args)



# -- General configuration ---------------------------------------------------
highlight_language = 'cmake'
templates_path = ['.templates']
source_suffix = '.rst'
master_doc = 'index'
exclude_patterns = []
pygments_style = 'sphinx'
html_theme = 'sphinx_rtd_theme'
html_static_path = []
htmlhelp_basename = project + 'doc'
extensions = [
    'sphinx.ext.mathjax',
    'sphinx.ext.githubpages',
]

# -- Options for LaTeX output ------------------------------------------------

latex_elements = {
}


latex_documents = [
    (master_doc, project + '.tex', project+ u'Documentation', author, 'manual'),
]

man_pages = [
    (master_doc,project, project+ u'Documentation', [author], 1)
]

texinfo_documents = [
    (master_doc, project, project + u'Documentation', author, project,
     'One line description of project.', 'Miscellaneous'),
]
epub_title = project
epub_author = author
epub_publisher = author
epub_copyright = copyright

# The unique identifier of the text. This can be a ISBN number
# or the project homepage.
#
# epub_identifier = ''

# A unique identification for the text.
#
# epub_uid = ''

# A list of files that should not be packed into the epub file.
epub_exclude_files = ['search.html']

# -- Generate documentation -------------------------------------------------

examples_dir = os.path.join(root_path, "tests", "cmake_test", "tutorials")
tutorial_dir = os.path.join(doc_path,  "source", "tutorials")
make_tutorials(examples_dir, tutorial_dir)


