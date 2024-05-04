# Discussion and Reflection


The bulk of this project consists of a collection of five
questions. You are to answer these questions after spending some
amount of time looking over the code together to gather answers for
your questions. Try to seriously dig into the project together--it is
of course understood that you may not grasp every detail, but put
forth serious effort to spend several hours reading and discussing the
code, along with anything you have taken from it.

Questions will largely be graded on completion and maturity, but the
instructors do reserve the right to take off for technical
inaccuracies (i.e., if you say something factually wrong).

Each of these (six, five main followed by last) questions should take
roughly at least a paragraph or two. Try to aim for between 1-500
words per question. You may divide up the work, but each of you should
collectively read and agree to each other's answers.

[ Question 1 ] 

For this task, you will three new .irv programs. These are
`ir-virtual?` programs in a pseudo-assembly format. Try to compile the
program. Here, you should briefly explain the purpose of ir-virtual,
especially how it is different than x86: what are the pros and cons of
using ir-virtual as a representation? You can get the compiler to to
compile ir-virtual files like so: 

racket compiler.rkt -v test-programs/sum1.irv 

(Also pass in -m for Mac)

** Answer 1 **

The purpose of ir-virtual is to create an intermediate step between
the racket syntax of ifarith, ifarith-tiny, and anf, and the compiled 
syntax of x86. Ir-virtual labels each let statement in the anf code, 
which are generated for each statement in ifarith-tiny so that operations 
are executed one at a time. These labels indicate to the ir-virtual->x86 
function that some movement or action has taken place. This is necessary 
because operations jmp, jz, and call all reference other operations and might 
not utilize all the labeled operations in a piece of code. This is 
particulary important for if statements, where depending on the truth 
value of the if, certain branches might not be reached. The reachability
of labeled branches is determined used labels-used and reachable-labels in 
ir-virtual->x86. Beyond labeling, ir-virtual also begins the process of 
encoding operations to x86 with intermidiary names like mov-lit and mov-reg.
Such operations make the execution path of the code more clear, but need to 
be broken into additional x86 operations to actually execute.

Pros: Easier to read than x86, labels operations for x86 conversion
Cons: Only accepts anf formatting, doesn't take into account stack allocation

Sample .irv programs:

1.) 
    ifarith-tiny: '(+ 1 2)

    ir-virtual:

    (((label lab111896) (mov-lit x111796 1))
      ((label lab111897) (mov-lit x111797 2))
      ((label lab111898) (mov-reg x111798 x111796))
      (add x111798 x111797)
      (return x111798))
      
2.) 
    ifarith-tiny: '(if 0 1 2)
    
    ir-virtual:

    (((label lab121711) (mov-lit x121607 0))
      ((label lab121712) (mov-lit zero121717 0))
      (cmp x121607 zero121717)
      (jz lab121713)
      (jmp lab121715)
      ((label lab121713) (mov-lit x121608 1))
      (return x121608)
      ((label lab121715) (mov-lit x121609 2))
      (return x121609))

3.) 
    ifarith-tiny: '(let ((x 1)) (+ x 1))
        
    ir-virtual:

    (((label lab122217) (mov-lit x122123 1))
      ((label lab122218) (mov-reg x x122123))
      ((label lab122219) (mov-lit x122124 1))
      ((label lab122220) (mov-reg x122125 x))
      (add x122125 x122124)
      (return x122125))

** End Answer 1 **

[ Question 2 ] 

For this task, you will write three new .ifa programs. Your programs
must be correct, in the sense that they are valid. There are a set of
starter programs in the test-programs directory now. Your job is to
create three new `.ifa` programs and compile and run each of them. It
is very much possible that the compiler will be broken: part of your
exercise is identifying if you can find any possible bugs in the
compiler.

For each of your exercises, write here what the input and output was
from the compiler. Read through each of the phases, by passing in the
`-v` flag to the compiler. For at least one of the programs, explain
carefully the relevance of each of the intermediate representations.

For this question, please add your `.ifa` programs either (a) here or
(b) to the repo and write where they are in this file.

[ Question 3 ] 

Describe each of the passes of the compiler in a slight degree of
detail, using specific examples to discuss what each pass does. The
compiler is designed in series of layers, with each higher-level IR
desugaring to a lower-level IR until ultimately arriving at x86-64
assembler. Do you think there are any redundant passes? Do you think
there could be more?

In answering this question, you must use specific examples that you
got from running the compiler and generating an output.

[ Question 4 ] 

This is a larger project, compared to our previous projects. This
project uses a large combination of idioms: tail recursion, folds,
etc.. Discuss a few programming idioms that you can identify in the
project that we discussed in class this semester. There is no specific
definition of what an idiom is: think carefully about whether you see
any pattern in this code that resonates with you from earlier in the
semester.

[ Question 5 ] 

In this question, you will play the role of bug finder. I would like
you to be creative, adversarial, and exploratory. Spend an hour or two
looking throughout the code and try to break it. Try to see if you can
identify a buggy program: a program that should work, but does
not. This could either be that the compiler crashes, or it could be
that it produces code which will not assemble. Last, even if the code
assembles and links, its behavior could be incorrect.

To answer this question, I want you to summarize your discussion,
experiences, and findings by adversarily breaking the compiler. If
there is something you think should work (but does not), feel free to
ask me.

Your team will receive a small bonus for being the first team to
report a unique bug (unique determined by me).

[ High Level Reflection ] 

In roughly 100-500 words, write a summary of your findings in working
on this project: what did you learn, what did you find interesting,
what did you find challenging? As you progress in your career, it will
be increasingly important to have technical conversations about the
nuts and bolts of code, try to use this experience as a way to think
about how you would approach doing group code critique. What would you
do differently next time, what did you learn?

