# Error or Issue Template

- **Date:**
- **Error or Issue Name:** New Display Manager Issues
- **Notes on Mitigation Efforts**
  - attempt to install lightdm-webkit2-greeter as instructed online did not work
    - corrupted a narhash, reinstall needed to fix the issue
    - I could still try to copy other **NUR** installs in this config more precisely instead of relying on the instructions on the github issue
      - `TODO try this`
    - using the ly module I found in the `the-argus` config sort of worked, after logging into X but it didn't recognize awesomewm's session and I don't have the spare life to debug a display manager I would rather not use
    - greetd seems geared to wayland, which I am not using
      - also uses gtk theme and all the same things I use for lightdm's gtk greeter so what would even be the advantage
        - just seems like more debugging I would rather not do honestly.
- **Solution or Verdict:** *TBD*
