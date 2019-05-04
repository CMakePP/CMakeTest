import os
import re

def parse_file(file, docs):
    #Get a list of functions in the file (note regex also grabs function() from
    #endfunction() (ditto for macro)

    f_contents = file.read()

    fxns = f_contents.split("endfunction()")
    macros = f_contents.split("endmacro()")
    for fxn_list, fxn_type in ((fxns, "function"), (macros, "macro")):
        for fxn_i in fxn_list:
            fxn_re= r"""{}\((.*?)(?:( .*)\)|\))""".format(fxn_type)
            fxn_name_re = re.compile(fxn_re)
            fxn_name_list = re.search(fxn_name_re, fxn_i)
            if fxn_name_list == None:
                continue
            fxn_name = fxn_name_list.group(1)
            fxn_args = fxn_name_list.group(2)
            fxn_re = "{}\({}".format(fxn_type, fxn_name)
            fxn_doc = re.compile(r"""## ((?:.*\n)*?){}""".format(fxn_re))
            doc = re.search(fxn_doc, fxn_i)
            if doc == None:
                #print("WARNING: No documentation for fxn {}".format(fxn_name))
                continue
            #Still has the #'s from the block comment, get rid of those by...

            #...assuming there's a space between the # and the comment
            doc = doc.group(1).replace('# ', '')

            #...and now clear any residual #, like those making blank lines
            doc = doc.replace('#', '')

            #Figure out the prefix on the variables by skimming fxn's name
            fxn_name_parts = fxn_name.split('_')
            letters = [word[0] if len(word) else '_' for word in fxn_name_parts]
            abbrv = ''.join(letters)

            #Take prefix off of the arguments
            if not fxn_args:
                fxn_args = ""
            fxn_args = [ var.replace(abbrv + '_', '') for var in fxn_args.split()]

            #Piece the actual reST function command together
            fxn_line = ".. function:: {}(".format(fxn_name)
            if len(fxn_args):
                for var in fxn_args[:-1]:
                    fxn_line = "{}<{}> ".format(fxn_line, var)
                fxn_line = "{}<{}>)".format(fxn_line, fxn_args[-1])
            else:
                fxn_line = "{})".format(fxn_line)

            #Add the parsed documentation to it
            fxn_line = fxn_line + "\n"
            for line in doc.split('\n'):
                fxn_line = "{}\n    {}".format(fxn_line, line)

            #reST has problems if the name starts with an underscore
            sanitized_name = fxn_name.replace("_cpp", "cpp")

            #Make the header for the file
            header = ".. _{}-label:\n\n".format(sanitized_name)
            header += "{}\n{}\n\n".format(sanitized_name, '#'*len(sanitized_name))

            docs[sanitized_name + ".rst"] = header + fxn_line

def parse_dir(root_dir, docs):
    for file in os.listdir(root_dir):
        full_file = os.path.join(root_dir, file)
        if os.path.isdir(full_file):
            print(full_file)
            sub_docs = {}
            parse_dir(full_file, sub_docs)

            #Start an index file for this module
            index_content = "\n{}\n{}\n\n".format(file, '#'*len(file))
            index_content += "Contents\n========\n\n"
            index_content += ".. toctree::\n    :maxdepth: 2\n\n"

            for k,v in sub_docs.items():
                index_content += "    {}\n".format(k.replace(".rst", ''))
                docs[os.path.join(file, k)] = v
            docs[os.path.join(file, "index.rst")] = index_content

        else:
            with open(full_file, "r") as f:
                parse_file(f, docs)

def main():
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    root_dir = os.path.dirname(curr_dir)
    source_dir = os.path.join(root_dir, "cmake")

    docs = {}
    parse_dir(source_dir, docs)
    output_dir = os.path.join(root_dir, "docs", "source", "apis")

    for k,v in docs.items():
        relative_dir = os.path.dirname(k)
        full_path = os.path.join(output_dir, relative_dir)
        if not os.path.isdir(full_path):
            os.makedirs(full_path)
        with open(os.path.join(output_dir,k), "w") as f:
            f.write(v)


if __name__ == "__main__":
    main()
