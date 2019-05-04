import apply_license
import doc_parser
import os
from subprocess import call

#Probably should be renamed, but basically this little script runs all the other
#scripts for you.

def main():
    apply_license.main()
    doc_parser.main()

    # Make the documentation
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    root_dir = os.path.dirname(curr_dir)
    doc_dir = os.path.join(root_dir, "docs")
    os.chdir(doc_dir)
    call(["make", "html"])

if __name__ == "__main__":
    main()
