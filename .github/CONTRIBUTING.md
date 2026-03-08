# Contributing to Ciano

Thank you for your interest in contributing to Ciano ❤️

Ciano is a simple multimedia file converter built with Vala and GTK,
focused on providing a clean and intuitive user experience.

------------------------------------------------------------------------

## 🐛 Reporting Bugs

Before opening a new issue:

-   Make sure the issue has not already been reported.
-   Use the latest available version of Ciano.
-   Provide clear steps to reproduce the issue.
-   Include your distribution and version (e.g., Ubuntu 24.04,
    elementary OS 8).

If possible, attach logs or screenshots.

------------------------------------------------------------------------

## 💡 Suggesting Features

Feature requests are welcome.

Please: - Clearly describe the problem you want to solve. - Explain why
the feature would benefit users. - Keep in mind that Ciano focuses on
simplicity.

------------------------------------------------------------------------

## 🔧 Development Setup

### Requirements

-   meson
-   valac
-   libgranite-dev
-   libgtk-3-dev
-   ffmpeg
-   imagemagick

### Build Instructions

``` bash
git clone https://github.com/robertsanseries/ciano.git
cd ciano
meson build
cd build
meson configure -Dprefix=/usr
ninja
```

Run locally:

``` bash
./com.github.robertsanseries.ciano
```

------------------------------------------------------------------------

## 🧱 Code Style

-   Follow existing project structure.
-   Keep methods small and readable.
-   Avoid unnecessary abstractions.
-   Maintain simplicity in UI and UX.
-   Follow Vala and GTK best practices.

If unsure, check existing files before introducing new patterns.

------------------------------------------------------------------------

## 🔀 Pull Requests

Before submitting a PR:

-   Ensure the project builds without errors.
-   Test your changes manually.
-   Keep PRs focused on a single change.
-   Write clear commit messages.

Example commit style:

Fix: prevent crash when converting empty file\
Add: support for WebP image conversion\
Refactor: simplify conversion pipeline logic

------------------------------------------------------------------------

## 🌍 Translations

Translations are welcome.

Please follow the existing localization structure and test your changes
before submitting.

------------------------------------------------------------------------

## ❤️ Code of Conduct

Be respectful and constructive.

We aim to keep Ciano a welcoming project for everyone.
