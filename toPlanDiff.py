from src.script import run_to_plan_diff
import argparse as ap
import logging

# python toPlanDiff.py Plans/testcase-simple.dot --base Plans/baseplan.txt --opt Plans/optplan.txt 

if __name__ == "__main__":
    parser = ap.ArgumentParser()
    parser.add_argument(
        "ag", type=str, help="Path to the AG file. It must be a DOT file."
    )

    parser.add_argument(
        "--ro",
        type=str,
        default="",
        help="Path to the revision operator file. It must be a JSON file."
    )
    parser.add_argument(
        "--base",
        type=str,
        help="Path to the base plan file. It must be a file created by the OPTIC planner."
    )
    parser.add_argument(
        "--opt",
        type=str,
        help="Path to the base plan file.  It must be a file created by the OPTIC planner."
    )

    parser.add_argument(
        "--log",
        type=str,
        default="INFO",
        help="Logging level"
    )

    args = parser.parse_args()

    log_level = getattr(logging, args.log.upper(), logging.INFO)
    logging.basicConfig(level=log_level, format='%(levelname)s %(asctime)s: %(message)s')

    run_to_plan_diff(args.ag, args.ro, args.base, args.opt)
