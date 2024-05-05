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

** Answer 2 **

1.) 
    q2_1.ifa: (print (+ 1 2))
    
    - intended to print "3"

    ifarith-tiny: '(print (+ 1 2))
    
    - no change since ifarith and ifarith-tiny 
        don't differ on implementation of print
    
    anf: 
        '(let ((x1254 1))
        (let ((x1255 2)) (let ((x1256 (+ x1254 x1255))) (print x1256))))
   
    - converts each member of expression into a let statement so that 
        they are executed one step at a time
        
    ir-virtual: 
        '(((label lab1257) (mov-lit x1254 1))
          ((label lab1258) (mov-lit x1255 2))
          ((label lab1259) (mov-reg x1256 x1254))
          (add x1256 x1255)
          ((label lab1260) (print x1256))
          (return 0))
          
    - labels movements so that x86 conversion knows which are reachable,
        breaks let statements of anf expression into simplified x86 operations 
        to lead to an easier conversion
    
    x86:
        section .data
            int_format db "%ld",10,0


            global _main
            extern _printf
        section .text


        _start:    call _main
            mov rax, 60
            xor rdi, rdi
            syscall


        _main:    push rbp
            mov rbp, rsp
            sub rsp, 48
            mov esi, 1
            mov [rbp-24], esi
            mov esi, 2
            mov [rbp-16], esi
            mov esi, [rbp-24]
            mov [rbp-8], esi
            mov edi, [rbp-16]
            mov eax, [rbp-8]
            add eax, edi
            mov [rbp-8], eax
            mov esi, [rbp-8]
            lea rdi, [rel int_format]
            mov eax, 0
            call _printf
            mov rax, 0
            jmp finish_up
        finish_up:    add rsp, 48
            leave 
            ret
    
    - final machine code to be placed in an .asm file to be run, breaks up 
        simplified ir-virtual operations into their more granular operations, 
        allocates necessary stack space according to the number of registers needed 
        (hence the addition of "mov rbp, rsp", "sub rsp, 48", and "add rsp, 48"
        
    OUTPUT: 
        (base) isaaclehigh@Isaacs-Air ~ % /Users/isaaclehigh/Documents/Documents/CIS\ 352/CIS352Final/test-programs/q2_1 ; exit;
        3

        Saving session...
        ...copying shared history...
        ...saving history...truncating history files...
        ...completed.
        
        [Process completed]
     
2.) 
    q2_2.ifa: (let* ((x (+ 3 4))) (print x))
    
    - intended to print "7"

    ifarith-tiny: '(let ((x (+ 3 4))) (print x))
    
    - let* is re-encoded as a let to reduce number of forms 
    
    anf: 
        '(let ((x1254 3))
           (let ((x1255 4))
             (let ((x1256 (+ x1254 x1255))) (let ((x x1256)) (print x)))))
   
    - converts each member of expression into a let statement so that 
        they are executed one step at a time
        
    ir-virtual: 
        '(((label lab1257) (mov-lit x1254 3))
          ((label lab1258) (mov-lit x1255 4))
          ((label lab1259) (mov-reg x1256 x1254))
          (add x1256 x1255)
          ((label lab1260) (mov-reg x x1256))
          ((label lab1261) (print x))
          (return 0))
          
    - labels movements so that x86 conversion knows which are reachable,
        breaks let statements of anf expression into simplified x86 operations 
        to lead to an easier conversion
    
    x86:
        section .data
            int_format db "%ld",10,0


            global _main
            extern _printf
        section .text


        _start:    call _main
            mov rax, 60
            xor rdi, rdi
            syscall


        _main:    push rbp
            mov rbp, rsp
            sub rsp, 64
            mov esi, 3
            mov [rbp-24], esi
            mov esi, 4
            mov [rbp-16], esi
            mov esi, [rbp-24]
            mov [rbp-8], esi
            mov edi, [rbp-16]
            mov eax, [rbp-8]
            add eax, edi
            mov [rbp-8], eax
            mov esi, [rbp-8]
            mov [rbp-32], esi
            mov esi, [rbp-32]
            lea rdi, [rel int_format]
            mov eax, 0
            call _printf
            mov rax, 0
            jmp finish_up
        finish_up:    add rsp, 64
            leave 
            ret 
    
    - final machine code to be placed in an .asm file to be run, breaks up 
        simplified ir-virtual operations into their more granular operations, 
        allocates necessary stack space according to the number of registers needed 
        (hence the addition of "mov rbp, rsp", "sub rsp, 48", and "add rsp, 48"
        
    OUTPUT: 
        (base) isaaclehigh@Isaacs-Air ~ % /Users/isaaclehigh/Documents/Documents/CIS\ 352/CIS352Final/test-programs/q2_2 ; exit;
        7

        Saving session...
        ...copying shared history...
        ...saving history...truncating history files...
        ...completed.

        [Process completed]

3.) 
    q2_2.ifa: (let* ((x (+ 3 4)) (y (- x 2)) (z (+ x y))) (print z))
    
    - intended to print "12"

    ifarith-tiny: '(let ((x (+ 3 4))) (let ((y (- x 2))) (let ((z (+ x y))) (print z))))
    
    - let* is re-encoded as a let to reduce number of forms, wraps statement in multiple 
        single pair lets so that the behaviour of let* is retained
    
    anf: 
        '(let ((x1254 3))
           (let ((x1255 4))
             (let ((x1256 (+ x1254 x1255)))
               (let ((x x1256))
                 (let ((x1257 2))
                   (let ((x1258 (- x x1257)))
                     (let ((y x1258))
                       (let ((x1259 (+ x y))) (let ((z x1259)) (print z))))))))))
   
    - converts each member of expression into a let statement so that 
        they are executed one step at a time
        
    ir-virtual: 
        '(((label lab1260) (mov-lit x1254 3))
          ((label lab1261) (mov-lit x1255 4))
          ((label lab1262) (mov-reg x1256 x1254))
          (add x1256 x1255)
          ((label lab1263) (mov-reg x x1256))
          ((label lab1264) (mov-lit x1257 2))
          ((label lab1265) (mov-reg x1258 x))
          (sub x1258 x1257)
          ((label lab1266) (mov-reg y x1258))
          ((label lab1267) (mov-reg x1259 x))
          (add x1259 y)
          ((label lab1268) (mov-reg z x1259))
          ((label lab1269) (print z))
          (return 0))
                    
    - labels movements so that x86 conversion knows which are reachable,
        breaks let statements of anf expression into simplified x86 operations 
        to lead to an easier conversion
    
    x86:
        section .data
            int_format db "%ld",10,0


            global _main
            extern _printf
        section .text


        _start:    call _main
            mov rax, 60
            xor rdi, rdi
            syscall


        _main:    push rbp
            mov rbp, rsp
            sub rsp, 144
            mov esi, 3
            mov [rbp-24], esi
            mov esi, 4
            mov [rbp-16], esi
            mov esi, [rbp-24]
            mov [rbp-8], esi
            mov edi, [rbp-16]
            mov eax, [rbp-8]
            add eax, edi
            mov [rbp-8], eax
            mov esi, [rbp-8]
            mov [rbp-32], esi
            mov esi, 2
            mov [rbp-72], esi
            mov esi, [rbp-32]
            mov [rbp-64], esi
            mov edi, [rbp-72]
            mov eax, [rbp-64]
            sub eax, edi
            mov [rbp-64], eax
            mov esi, [rbp-64]
            mov [rbp-40], esi
            mov esi, [rbp-32]
            mov [rbp-56], esi
            mov edi, [rbp-40]
            mov eax, [rbp-56]
            add eax, edi
            mov [rbp-56], eax
            mov esi, [rbp-56]
            mov [rbp-48], esi
            mov esi, [rbp-48]
            lea rdi, [rel int_format]
            mov eax, 0
            call _printf
            mov rax, 0
            jmp finish_up
        finish_up:    add rsp, 144
            leave 
            ret 

    
    - final machine code to be placed in an .asm file to be run, breaks up 
        simplified ir-virtual operations into their more granular operations, 
        allocates necessary stack space according to the number of registers needed 
        (hence the addition of "mov rbp, rsp", "sub rsp, 48", and "add rsp, 48"
        
    OUTPUT: 
        (base) isaaclehigh@Isaacs-Air ~ % /Users/isaaclehigh/Documents/Documents/CIS\ 352/CIS352Final/test-programs/q2_3 ; exit;
        12

        Saving session...
        ...copying shared history...
        ...saving history...truncating history files...
        ...completed.

        [Process completed]
        
** End Answer 2 **

[ Question 3 ] 

Describe each of the passes of the compiler in a slight degree of
detail, using specific examples to discuss what each pass does. The
compiler is designed in series of layers, with each higher-level IR
desugaring to a lower-level IR until ultimately arriving at x86-64
assembler. Do you think there are any redundant passes? Do you think
there could be more?

In answering this question, you must use specific examples that you
got from running the compiler and generating an output.

** Answer 3 ** 

The compiler first converts from the ifarith language to a simplified 
version called ifarith-tiny. This strips away the complexity of handling 
and, or, and cond statements in favor of utilizing if. It also changes 
let* bindings and multiple binding let*'s into let statements with one 
binding that wrap around the whole expression. A conversion of a let* 
looks like this: '(let* ((x 1)) (+ x 1)) -> '(let ((x 1)) (+ x 1))

Next, the compiler converts the ifarith-tiny into administrative normal 
form which breaks each operation and value in the code into a let statement, 
ensuring that the process is executed one step at a time. Continuing with 
the example detailed above, the ifarith-tiny->anf conversion looks like this: 
'(let ((x 1)) (+ x 1)) -> '(let ((x122123 1)) (let ((x x122123)) 
                    (let ((x122124 1)) (let ((x122125 (+ x x122124))) x122125))))

Next, the anf code is converted into IR-Virtual which converts the code into 
a form much closer to assembly, converting value to variable assignments like 
'(let ((x122123 1))) into '(mov-lit x122123 1) and variable to variable assignments 
like '(let ((x x122123))) into '(mov-reg x x122123). Each movement is also labeled for 
traceability and jump functionality.

Finally, IR-Virtual code is broken up further into the respective assembly 
operations that make it up. Operations like '(mov-lit x122123 1) get translated 
into "(mov "esi" "1") (mov "[rbp-32]" "esi")" which creates a spot in memory that 
holds the value 1. To assign 1 to x, '(mov-reg x x122123) is changed to 
"(mov "esi" "[rbp-32]") (mov "[rbp-8]" "esi")" which uses the temporary value 
"esi" to copy the location in memory where 1 is stored over to a new location 
representing x. Necessary stack space is also freed up at the start of the x86 
code.

The amount of passes seems to be the right amount generally. Each pass 
changes the code in a meaningful way that contributes to its final form as x86. 
However, with the way the compiler is written, some redundancy is introduced when assigning 
variables. This process entails moving values into a temporary register, copying that register to 
memory, copying that spot in memory to the temporary register, then copying the temporary 
register to a spot in memory for the variable. Instead, if there was extra discernment built 
into either the anf or the ir-virtual conversion, the value could be directly placed in memory to 
represent the variable.

** End Answer 3 ** 

[ Question 4 ] 

This is a larger project, compared to our previous projects. This
project uses a large combination of idioms: tail recursion, folds,
etc.. Discuss a few programming idioms that you can identify in the
project that we discussed in class this semester. There is no specific
definition of what an idiom is: think carefully about whether you see
any pattern in this code that resonates with you from earlier in the
semester.

** Answer 4 ** 

Idioms: 
    
    1.) Custom programming language semantics: We used custom programming 
        languages in Projects 3 and 4, and it is in this project too in the 
        form of ifarith
    2.) Match: Pattern matching lists was used extensively throughout the course
        and it is a key component in this project as well.
    3.) Helper functions: Throughout all of the projects in this class, helper 
        functions have been crucial to building up larger functions. They are used 
        extensively in this project, some examples are normalize-term, normalize, 
        name->op, and linearize.
    4.) Tail recursion: During this course, tail recursion was taught as a way to 
        create recursive functions without adding to the stack. This project utilizes 
        foldl which is a racket built-in that utilizes tail recursion.
    5.) Compiling: Project 4 had us take a similar, but more extensive language than 
        the ifarith in this project, and convert it into the church-encoded lambda 
        calculus. This is similar to what needs to be done for this project, since 
        the input programs are both in the form of a list, and are recursively 
        traversed and translated into the desired form.
    6.) Sets: This project uses sets to hold un-ordered groups of data, such as 
        labels and registers used in ir-virtual. Sets were discussed in the class 
        and were included in the final exam review as well.
    7.) Prefix notation: Racket uses prefix notation, so it is used for this whole 
        project as well as all the previous ones, however it was an important concept 
        to learn early on in the semester.
        
** End Answer 4 ** 

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

** Answer 5 ** 

To start testing, the code was analyzed thoroughly. Early on it was theorized that
print might cause issues based on the given code for ifarith->ifarith-tiny. The 
expression wasn't recursively converted and instead returned in ifarith form. Because 
of this, a let* statement within the print should break the code, and this 
assumption was correct. An input of '(print (let* ((x 1)) x)) results in the error, 
match: no matching clause for '((x 1)), and the code cannot be compiled. This error 
can be fixed by replacing the current print match case with     
[`(print ,x) `(print ,(ifarith->ifarith-tiny x))], but considering the nature of this 
assignment, the given code was used so that the error persisted (the fixed code is 
commented out underneath the current match case). The file with this code is called 
q5_1.ifa.

It was also realized when 

[ High Level Reflection ] 

In roughly 100-500 words, write a summary of your findings in working
on this project: what did you learn, what did you find interesting,
what did you find challenging? As you progress in your career, it will
be increasingly important to have technical conversations about the
nuts and bolts of code, try to use this experience as a way to think
about how you would approach doing group code critique. What would you
do differently next time, what did you learn?


This is mark.
