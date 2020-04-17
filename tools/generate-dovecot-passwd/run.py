#!/usr/bin/env python3

import argparse
import getpass
import os
import subprocess
import sys


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--domain", required=True)
    parser.add_argument("--scheme", default="SSHA512")
    parser.add_argument("--users", nargs="+", required=True)
    parser.add_argument("--output")
    return parser.parse_args()


def prompt_password(address):
    while True:
        print(f"Choose a password for {address}", file=sys.stderr)
        password1 = getpass.getpass("Enter new password: ", stream=sys.stderr)
        password2 = getpass.getpass("Retype new password: ", stream=sys.stderr)
        if password1 == password2:
            return password1
        else:
            print("Passwords do not match!", file=sys.stderr)


def build_docker_image():
    subprocess.check_call(
        [
            "docker",
            "build",
            "--rm",
            "--tag=generate-dovecot-passwd",
            os.path.join(os.path.dirname(__file__), "image"),
        ],
        stdout=sys.stderr.buffer,
    )


def run_docker_image(scheme, plaintext_password):
    env = os.environ.copy()
    env.update({
        "DOVECOT_SCHEME": scheme,
        "DOVECOT_PASSWORD": plaintext_password,
    })

    output = subprocess.check_output(
        [
            "docker",
            "run",
            "--env=DOVECOT_SCHEME",
            "--env=DOVECOT_PASSWORD",
            "generate-dovecot-passwd",
        ],
        env=env,
    )
    return output.decode("utf-8").strip()


def generate_passwd_file_contents(domain, scheme, users):
    content = ""
    for user in users:
        address = f"{user}@{domain}"
        plaintext_password = prompt_password(address)
        hashed_password = run_docker_image(scheme, plaintext_password)
        content += f"{address}:{hashed_password}\n"
    return content


def main():
    args = parse_args()

    print("Populating Dovecot passwd file", file=sys.stderr)

    build_docker_image()

    content = generate_passwd_file_contents(
        args.domain,
        args.scheme,
        args.users,
    )

    if args.output and args.output != "-":
        with open(args.output, "w") as f:
            f.write(content)
        print(f"Wrote file {args.output}", file=sys.stderr)
    else:
        print(content, end="")


if __name__ == "__main__":
    main()
