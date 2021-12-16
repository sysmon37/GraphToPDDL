from src.script import run
import argparse as ap
import traceback


if __name__ == "__main__":
    parser = ap.ArgumentParser()
    parser.add_argument(
        "ag", type=str, help="Path to the AG file. It must be a DOT file."
    )

    parser.add_argument(
        "--ro",
        type=str,
        help="Path to the revision operator file. It must be a JSON file.",
    )
    parser.add_argument(
        "--p",
        type=str,
        help="Path to the patient values file. It must be a JSON file.",
    )
    parser.add_argument(
        "--p-name",
        type=str,
        default="problem",
        help="Problem name. It is also the name of the output PDDL file (e.g. --p-name problem).",
    )

    parser.add_argument(
        "--d-name",
        type=str,
        default="default_domain",
        help="Domain name.",
    )

    parser.add_argument(
        "--no-ro",
        action="store_true",
        default=False,
        help="If true, does not apply any revision operators. It will output the original graph with the corresponding PDDL.",
    )

    parser.add_argument(
        "--dir",
        type=str,
        default="",
        help="Path to the directory where to create the problem and graph view files. Default value is the current directory",
    )

    args = parser.parse_args()
    try:
        if not args.ag:
            raise Exception(
                "An AG (extended or not) file is needed. Please use the flag --ag or --agx followed by the path to the file.\nUse the flag -h for more information"
            )

        if args.ag and args.ag[-3:].lower() != "dot":
            raise Exception("The AG file (--ag) must be a DOT file.")

        if args.ro != None and args.ro[-4:].lower() != "json":
            raise Exception("The Revision operators file (--ro) must be a JSON file.")

        if args.p != None and args.p[-4:].lower() != "json":
            raise Exception("The Revision operators file (--ro) must be a JSON file.")
        run(args.ag, args.ro, args.p, args.no_ro, args.p_name, args.d_name, args.dir)
    except Exception as e:
        print(e)
        traceback.print_exc()
