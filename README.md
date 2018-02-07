# Getting Started With Ledger - The Book

*Getting Started With Ledger* is an introductory book for the excellent command line accounting tool [Ledger](http://ledger-cli.org/).

The book covers:

* The basics of (double entry) accounting.
* Installing & running basic Ledger.
* Setting up a fully automatic environment for production use.
* Integrating external data (CSV from banks etc.) into the journal.
* Generating the usual reports about one's financial situation automatically.
* Advanced topics like automated transactions (briefly).

## Get the book

Go the the [Releases](https://github.com/rolfschr/GSWL-book/releases) page and download the PDF file.

You can also browse the latest version on [GitHub](https://rolfschr.github.io/gswl-book/latest.html).

## Get the latest version

```bash
$ mkdir -p ~/src && cd ~/src
$ git clone https://github.com/rolfschr/GSWL-book.git
$ cd GSWL-book
$ make pdf # use pandoc to generate LaTeX & PDF file
```
