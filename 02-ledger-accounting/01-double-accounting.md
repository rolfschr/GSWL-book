
# An introduction to Ledger #

This chapter introduces the philosophy of double-entry accounting, Ledger as a command line tool  and its basic usage.


## Double-entry Accounting ##

Double-entry accounting is a standard bookkeeping approach.
In accounting, every type of expense or income and every "place" which holds monetary value is called an "account" (think "category").
Example accounts may be "Groceries", "Bike", "Holidays", "Checking Account of Bank X", "Salary" or "Mortgage".
In double-entry accounting, one tracks the flow of money from one account to another.
An amount of money always figures twice ("double") in the books: At the place where it came from and at the place where it was moved to.
That is, adding $1000 *here* means removing $1000 from *there* at the same time.
In consequence, *the total balance of all accounts is always zero.*
Money is never added to an account without stating where the exact same amount came from.
However, more than two accounts may be involved in one transaction.

For example, buying a book online for $15 moves money from the account "Creditcard X" to the account "Books".
Receiving a $2000 salary from your boss means moving $2000 from the account "Salary" to the account "Bank" (or whatever).
Buying groceries and detergent at the supermarket may move money from "Creditcard X" to both "Groceries" and "Household".

In general, account names depend on the situation.
But, one usually has the following main accounts:

* Expenses
* Income
* Assets
* Liabilities
* Receivables
* Equity

The level of detail needed for the subcategories ("Expenses" -> "Groceries" -> "Fruits" -> "Bananas") is up to the requirements.

## Ledger ##

[Ledger](http://ledger-cli.org) is a double-entry accounting command line tool.
It is an extremely potent tool and it takes some time and effort to be able to unleash its power.
However, once mastered there is not much you may miss while doing personal or professional accounting.

Extensive documentation can be found at [http://ledger-cli.org](http://ledger-cli.org).

Working with Ledger boils down to two distinct types of action: Updating the list of transactions (the "journal") and using Ledger to view/interpret that data.

Ledger follows good old Unix traditions and stores data in plain text files.
This data mainly includes the journal with the transactions and some meta information, too.
A typical transaction in Ledger looks like this:

~~~{.scheme}
2042/02/21 Shopping
	Expenses:Food:Groceries                 $42.00
	Assets:Checking                        -$42.00
~~~

Any transaction starts with a header line containing the date and some meta information (in the case above only a comment describing the transaction).
The header is then followed by a list of accounts involved in the transaction (one "posting" per line; each line starting with a whitespace).
Accounts have arbitrary names but Ledger uses the colon to distinguish between subcategories.
The account name is followed by at least two whitespaces and the amount of money which was added (positive) or removed (negative) from that same account.
Actually, Ledger is clever enough to calculate the appropriate amount so it would have been perfectly valid to only write:

~~~{.scheme}
2042/02/21 Shopping
    Expenses:Food:Groceries                 $42.00
    Assets:Checking
~~~

The journal file is as simple as that and there is not much to know about it at this point. 
Note that Ledger never modifies your files.

The following transactions illustrate some basic concepts used in double accounting & Ledger:

```
; The opening balance sets up your initial financial state.
; This is needed as one rarely starts with no money at all.
; Your opening balance is the first "transaction" in your journal.
; The account name is not special. We only need something convenient here.
2041/12/31 * Opening Balance
    Assets:Checking                       $1000.00
    Equity:OpeningBalances

; The money comes from the employer and goes into the bank account.
2041/01/31 * Salary
    Income:Salary                           -$1337
    Assets:Checking                          $1337

; Groceries were paid using the bank account's electronic cash card
; so the money comes directly from the bank account.
2042/02/15 * Shopping
    Expenses:Food:Groceries                 $42.00
    Assets:Checking

; Although we know the cash sits in the wallet, everything in cash is
; considered as "lost" until recovered (see next transaction and later chapters).
2042/02/15 * ATM withdrawal
    Expenses:Unknown                       $150.00
    Assets:Checking

; Paying food with cash: Moving money from the Expenses:Unknown
; account to the food account.
2042/02/15 * Shopping
    Expenses:Food:Groceries                 $23.00
    Expenses:Unknown

; Ledger automatically reduces 'Expenses:Unknown' by $69.
2042/02/22 * Shopping
    Expenses:Food:Groceries                 $23.00
    Expenses:Clothing                       $46.00
    Expenses:Unknown

; You can use positive (add money to an account) or negative
; (remove money from an account) amounts interchangeably.
2042/02/22 * Shopping
    Expenses:Food:Groceries
    Expenses:Unknown                       -$42.00
```

The above example already introduced some nice concepts from Ledger.
Still, reading the text file is a bit boring.
Before we let Ledger parse that for us, you'll probably still need to install it first ...

## Installing Ledger ##

Ledger's latest version can be obtained from its [website](http://ledger-cli.org/download.html).
I recommend to have at least version 3.0.3 running.

Further dependencies for the ecosystem presented in this book are:

* [Git](http://git-scm.com/)
* [Python](https://www.python.org/)

Optional but recommended:

* [tmux](http://tmux.sourceforge.net/)
* [tmuxinator](https://github.com/tmuxinator/tmuxinator) 
* [gnuplot](http://www.gnuplot.info/)

### Linux, Mac OS X & BSD ###

You'll find what you need at the [download site](http://ledger-cli.org/download.html).

When running Linux, it might just be a question of:

~~~{.bash}
$ sudo apt-get install ledger
# or
$ sudo yum install ledger
# or ...
~~~

However, the distribution's package might be older than the one provided at the download site.
Ledger comes with a very good installation documentation.
Refer to the [Github page](https://github.com/ledger/ledger) for more details.

### Windows ###

Ledger is hard to get running on Windows (you would probably need to compile it yourself and that's often a pain in the ass on Windows).
Additionally, the setup presented in this book makes heavy use of the traditional Unix command line infrastructure.
I therefore recommend to setup VirtualBox and install Ledger on a Linux machine.
You could either use plain VirtualBox or VirtualBox with Vanguard on top.
The latter is probably easier & faster.
It will be totally fine to connect to your virtual machine via SSH in Windows afterwards so you won't need to actually "use" the Linux environment.

Step-by-step Instructions (without Vagrant):

* Download and install [VirtualBox](https://www.virtualbox.org/).
* Download an ISO of a Linux distribution of your choice ([Ubuntu](http://www.ubuntu.com/desktop)?).
* Install Linux on the virtual machine.
* Install the OpenSSH *server* ("``$ sudo apt-get install openssh-server``" for Ubuntu).
* Make sure you can [access the vm via SSH](http://stackoverflow.com/a/10532299).
* Run the machine in [headless mode](https://www.virtualbox.org/manual/ch07.html#vboxheadless) if you want.
* Install [babun](https://github.com/babun/babun) (built on top of [Cygwin](https://www.cygwin.com/)) on your Windows machine.
* Connect to the vm via SSH.
* Follow the instructions to install Ledger on Linux.

Step-by-step Instructions (with Vagrant):

* Download and install [VirtualBox](https://www.virtualbox.org/) & [Vagrant](https://www.vagrantup.com/).
* Download this [Vagrantfile](https://github.com/rolfschr/GSWL-ecosystem/blob/master/contrib/Vagrantfile) from Github.
* Open a terminal, go to the Vagrantfile's location and run ``vagrant up`` (this will setup an Ubuntu machine with Ledger installed).
* To connect to the VM via SSH, use ``vagrant up`` followed by ``vagrant ssh`` from within the same folder.

## A first teaser ##

With a working installation of Ledger on your machine, grab these [sample transactions](https://gist.github.com/rolfschr/318f1f91f8f845864568) from Github (click the 'Raw' button) and copy them to a text file called ``journal.txt``.
Then run this:

~~~{.bash}
$ # Usage: ledger -f <journal-file> [...]
$ ledger -f journal.txt balance
$ ledger -f journal.txt balance Groceries
$ ledger -f journal.txt register
~~~

This should give you a first feeling for Ledger.
You will get to see more in the Reports chapter later.
But first, we need to get our own Ledger ecosystem set up.

\newpage
