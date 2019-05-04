import os

def make_license(year, author, comment_char):
    temp = """Copyright {1} {2}
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.""".format(comment_char, year, author)
    banner = comment_char * 80
    rv = banner + "\n"
    for l in temp.split('\n'):
        nspaces = 78 - len(l)
        nlspaces = (nspaces - nspaces%2)/2
        nrspaces = nlspaces + nspaces%2
        lspaces = " " * int(nlspaces)
        rspaces = " " * int(nrspaces)
        rv += "#" + lspaces + l + rspaces + "#\n"
    rv+=banner + "\n"
    return rv

def process_files(root_dir, lines_in_lic, new_license):
    for filename in os.listdir(root_dir):
        file_path = os.path.join(root_dir, filename)
        if os.path.isdir(file_path):
            process_files(file_path, lines_in_lic, new_license)
            continue
        temp_path = file_path + ".temp"
        if filename.endswith(".temp"):
            continue
        with open(file_path, "r") as f:
            lines = f.readlines()

            header = ''.join(lines[:lines_in_lic])
            if header == new_license+"\n":
                continue

            with open(temp_path, "w") as g:
                g.write(new_license + "\n")
                for l in lines:
                    g.write(l)
        os.remove(file_path)
        os.rename(temp_path, file_path)


def main() :
    year = "2018"
    author = "Ryan M. Richard"
    comment_char = '#'
    lines_in_lic = 15
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    root_dir = os.path.dirname(curr_dir)
    new_license = make_license(year, author, comment_char)

    source_dir = os.path.join(root_dir, "cmake")
    process_files(source_dir, lines_in_lic, new_license)


if __name__ == "__main__":
    main()
