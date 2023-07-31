% for information about this template, visit
%   https://github.com/rutar-academic/template-preprint
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mathprint}[2023/07/13 Mathematics Preprint Class]

\DeclareOption{toc}{\AfterEndEnvironment{abstract}{\setcounter{tocdepth}{2}\tableofcontents}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper,twoside,leqno]{article}
\RequirePackage[left=3cm, right=3cm, top=3cm, bottom=3cm]{geometry}
\RequirePackage[leqno]{amsmath} % process leqno option

% core package loads
% ------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[protrusion=true,expansion=true]{microtype}
\RequirePackage[french,english]{babel}
\RequirePackage{etoolbox}
\RequirePackage{csquotes}

\RequirePackage{mathtools}

\RequirePackage{stmaryrd}
\SetSymbolFont{stmry}{bold}{U}{stmry}{m}{n} % fix missing bold font error

\allowdisplaybreaks

% styling
% -------

% fonts
\RequirePackage{palatino}

% captions
\RequirePackage[
  labelfont={sc},
  singlelinecheck=true, % centered single-lined captions
  format=plain,
  margin=1cm,
  labelsep={period},
]{caption}

% section headers
\RequirePackage{titlesec}
\newcommand{\addperiod}[1]{#1.}

\titleformat{\section}[block]%
  {\large\scshape\filcenter}% format
  {\thesection.}% label
  {1em}% sep
  {}% before-code

\titleformat{\subsection}[runin]%
  {\bfseries\filright}% format
  {\thesubsection.}% label
  {.5em}% sep
  {\addperiod}% before-code

\titleformat{\subsubsection}[runin]%
  {\itshape\filright}% format
  {\thesubsubsection.}% label
  {.5em}% sep
  {\addperiod}% before-code


% redefine abstract to be inline
\renewenvironment{abstract}
 {\small
  \begin{quotation}\textsc{Abstract.}~}
  {\end{quotation}}

\RequirePackage{longtable}

% build author lists
\RequirePackage{xstring}
\newcommand{\@makeauthlist}[1]{%
    \ifnumequal{\value{sepcount}}{-1}{#1}{%
        \ifnumequal{\value{sepcount}}{0}{\StrSubstitute{#1}{,~\&~}{~\&~}}{%
            \StrSubstitute[\value{sepcount}]{#1}{,~\&~}{,~}%
}}}

% allow inputting multiple authors with separate commands
\newcommand*\@authors{}
\newcounter{sepcount}
\setcounter{sepcount}{-2}
\newcommand*\@headauthors{}
\newcommand*\@addresslist{}
\renewcommand*\author[4][]{%
   \stepcounter{sepcount}
   \ifx\@authors\empty
     \def\@authors{#2}%
   \else
     \g@addto@macro\@authors{,~\&~#2}%
   \fi
   \ifx\@headauthors\empty
       \def\@headauthors{\ifstrempty{#1}{#2}{#1}}%
   \else
       \g@addto@macro\@headauthors{,~\&~\ifstrempty{#1}{#2}{#1}}%
   \fi
   \ifx\@addresslist\empty%
   \else
     \g@addto@macro\@addresslist{\\}
   \fi
   \g@addto@macro\@addresslist{
     \begin{minipage}[t]{0.95\textwidth}
       \itshape\textbf{#2}
       \ifstrempty{#2}{}{\\#3}
       \ifstrempty{#3}{}{\\\normalfont Email: \href{mailto:#3}{\texttt{#4}}}
     \end{minipage}%
   }
}

\newcommand*\@shorttitle{}

% customize title printing
\renewcommand\title[2][]{\renewcommand\@title{#2}\ifstrempty{#1}{\renewcommand\@shorttitle{#2}}{\renewcommand\@shorttitle{#1}}}
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large\scshape
      \lineskip .5em%
      \@makeauthlist{\@authors}}%
  \end{center}%
  \par
  \vskip 1.5em}

% generate headers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\setlength{\headheight}{14pt}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhf{}
\fancyhead[CE]{\small\scshape\@makeauthlist{\@headauthors}}
\fancyhead[CO]{\small\scshape\@shorttitle}
\fancyhead[LE]{\small\thepage}
\fancyhead[RO]{\small\thepage}

% generate footnote with journal for titlepage with \journal command
\newcommand*\@journal{}
\newcommand{\journal}[1]{\def\@journal{%
  \renewcommand{\footrulewidth}{0.4pt}%
  \fancyfoot[L]{\footnotesize \textit{Journal ref.}\enspace #1}
}}

\def\footrule{\nointerlineskip\if@fancyplain\let\footrulewidth\plainfootrulewidth\fi%
    {\rule{0.25\textwidth}{\footrulewidth}} \vskip-\footrulewidth}

\newcommand{\journalcite}[1]{\journal{\textcite{#1}}}

\newcommand{\journalurl}[1]{\def\@journal{%
  \renewcommand{\footrulewidth}{0.4pt}%
  \fancyfoot[L]{\footnotesize \textit{Available online.}\enspace \url{#1}}
}}

\fancypagestyle{plain}{\fancyhf{}\@journal} % set `plain` pagestyle which is used for the first page only

% custom acknowledgements environment
\newenvironment{acknowledgements}
  {\section*{Acknowledgements}\addcontentsline{toc}{section}{Acknowledgements}}
  {}

% print title, bibliography, and addresslist
\AtBeginDocument{\maketitle}
\AtEndDocument{\printbibliography\renewcommand*{\arraystretch}{2.5}\noindent\begin{longtable}{l}\@addresslist\end{longtable}}

\AtEndPreamble{
  \hypersetup{
    pdfauthor = \@authors,
    pdftitle = \@title
  }
}

% warnings if things are missing
\AtBeginDocument{\ifx\@authors\empty\ClassError{mathprint}{No authors provided}\fi}

% ntheorem
% --------
\RequirePackage[thmmarks,amsmath,hyperref]{ntheorem}

% main theorems, etc.
\theoremstyle{plain}
\theorembodyfont{\itshape}
\theoremheaderfont{\bfseries\boldmath\upshape}
\theoremseparator{.}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{conjecture}[theorem]{Conjecture}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{question}[theorem]{Question}

% custom theorem for referencing
\newtheorem*{restatementbase}{Restatement}
\newenvironment{restatement}[1]{\begin{restatementbase}[of~\cref{#1}]}{\end{restatementbase}}

% theorems for introduction (alphabetic numbering)
\newtheorem{itheorem}{Theorem}[section]
\renewcommand*{\theitheorem}{\Alph{itheorem}}
\newtheorem{icorollary}[itheorem]{Corollary}
\renewcommand*{\theicorollary}{\Alph{icorollary}}

% Claim environment
\theoremheaderfont{\itshape\bfseries\boldmath}
\theorempreskip{0.2cm}
\theorempostskip{0.2cm}
\newtheorem{claim}{Claim}
\renewcommand\theclaim{\Roman{claim}}
\AtBeginEnvironment{theorem}{\setcounter{claim}{0}}

% Proof part
\newtheorem{proofpart}{Part}
\renewcommand\theproofpart{\Roman{proofpart}}
\AtBeginEnvironment{theorem}{\setcounter{proofpart}{0}}

% Case environment
\newcounter{casect}
\AtBeginEnvironment{proof}{\setcounter{casect}{0}}
\newcommand{\case}[1]{\stepcounter{casect}\textit{Case \thecasect: #1.}}


% upshape theorems
\theorembodyfont{\upshape}
\theoremheaderfont{\bfseries\boldmath\upshape}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{notation}[theorem]{Notation}
\newtheorem{example}[theorem]{Example}
\newtheorem{remark}[theorem]{Remark}

% proof / solution environments
\theoremstyle{nonumberplain}
\theoremheaderfont{\hspace*{\parindent}\itshape}
\theoremsymbol{$//$}
\newtheorem{solution}{Solution}
\theoremsymbol{$\square$}
\theorempostskip{0.4cm}
\newtheorem{proof}{Proof}
\theoremsymbol{}
\newtheorem{nmproof}{Proof}


% biblatex
% --------
\RequirePackage[
  backend=biber,
  backref=false,
  clearlang=true,
  date=year,
  doi=false,
  giveninits=true,
  isbn=false,
  maxbibnames=99,
  minalphanames=3,
  natbib=true,
  sortcites=true,
  style=alphabetic,
  url=false
]{biblatex}

\AtBeginBibliography{\raggedright}
\AtBeginBibliography{\addcontentsline{toc}{section}{References}}
\AtBeginBibliography{\small}

% bold volume number; plain pages
\DeclareFieldFormat[article]{volume}{\mkbibbold{#1}}
\DeclareFieldFormat{pages}{#1}
\DeclareFieldFormat{journaltitle}{#1}
\DeclareFieldFormat{booktitle}{\mkbibquote{#1}}

% italicised title
\DeclareFieldFormat
  [article,preprint,inbook,incollection,inproceedings,thesis]
  {title}{\mkbibemph{#1\isdot}}

% custom formatting for preprints (with and without journal)
\newbibmacro*{preprint:journal}{\iffieldundef{journaltitle}{\printtext{Preprint}}{\printtext{To appear in:}\addspace\printfield{journaltitle}\newunit}}

% short journal name and volume (suppress number)
\newbibmacro*{journalshort}{%
  \usebibmacro{journal}%
  \setunit*{\addspace}%
  \printfield{volume}
  \setunit{\addspace}%
  \usebibmacro{issue+date}%
  \newunit}

\DeclareFieldFormat[preprint]{labelalpha}{#1+} % change formatting for manuscript

% eprint / archive
% define new eprinttype using e.g. `eprint:jstor` (see below for pattern)
\newbibmacro{archive}{\iffieldundef{eprinttype}
  {\printfield{eprint}}
  {\printfield[eprint:\strfield{eprinttype}]{eprint}}
}
\DeclareFieldFormat{eprint:arxiv}{\href{https://arxiv.org/abs/#1}{\nolinkurl{arxiv:#1}}}
\DeclareFieldFormat{eprint:zbl}{\href{https://zbmath.org/#1}{\nolinkurl{zbl:#1}}}
\DeclareFieldFormat{eprint:zbmath}{\href{https://zbmath.org/#1}{\nolinkurl{zbmath:#1}}}
\DeclareFieldFormat{eprint:doi}{\href{https://doi.org/#1}{\nolinkurl{doi:#1}}}
\DeclareFieldFormat{eprint:mr}{\href{https://mathscinet.ams.org/mathscinet-getitem?mr=#1}{\nolinkurl{MR#1}}}

% custom citation command
\DeclareCiteCommand{\textcite}{%
  \usebibmacro{journalshort}
  \newunit
  \usebibmacro{note+pages}%
  \usebibmacro{archive}%
\usebibmacro{finentry}}{}{}{}

% main drivers
\DeclareBibliographyDriver{preprint}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit\newblock
  \usebibmacro{preprint:journal}%
  \newunit\newblock
  \usebibmacro{archive}%
  \usebibmacro{finentry}}

\DeclareBibliographyDriver{article}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit\newblock
  \usebibmacro{byauthor}%
  \newunit\newblock
  \usebibmacro{journalshort}
  \newunit
  \usebibmacro{note+pages}%
  \usebibmacro{archive}%
  \usebibmacro{finentry}}

\DeclareBibliographyDriver{book}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/editor+others/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{maintitle+title}%
  \newunit\newblock
  \usebibmacro{byauthor}%
  \newunit\newblock
  \usebibmacro{byeditor+others}%
  \newunit\newblock
  \printfield{edition}%
  \newunit
  \iffieldundef{maintitle}
    {\printfield{volume}%
     \printfield{part}}
    {}%
  \newunit
  \printfield{volumes}%
  \newunit\newblock
  \usebibmacro{series+number}%
  \newunit\newblock
  \printfield{note}%
  \newunit\newblock
  \usebibmacro{publisher+location+date}%
  \newunit\newblock
  \usebibmacro{chapter+pages}%
  \newunit
  \printfield{pagetotal}%
  \newunit\newblock
  \usebibmacro{archive}%
  \usebibmacro{finentry}}

\DeclareBibliographyDriver{incollection}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit\newblock
  \usebibmacro{byauthor}%
  \newunit\newblock
  \usebibmacro{in:}
  \usebibmacro{maintitle+booktitle}%
  \newunit\newblock
  \usebibmacro{byeditor+others}%
  \newunit\newblock
  \printfield{edition}%
  \newunit
  \iffieldundef{maintitle}
    {\printfield{volume}%
     \printfield{part}}
    {}%
  \newunit
  \printfield{volumes}%
  \newunit\newblock
  \usebibmacro{series+number}%
  \newunit\newblock
  \printfield{note}%
  \newunit\newblock
  \usebibmacro{publisher+location+date}%
  \newunit\newblock
  \usebibmacro{chapter+pages}%
  \usebibmacro{archive}%
  \usebibmacro{finentry}}

\DeclareBibliographyDriver{inproceedings}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit\newblock
  \usebibmacro{byauthor}%
  \newunit\newblock
  \usebibmacro{in:}
  \usebibmacro{maintitle+booktitle}%
  \newunit\newblock
  \usebibmacro{byeditor+others}%
  \newunit\newblock
  \printfield{edition}%
  \newunit
  \iffieldundef{maintitle}
    {\printfield{volume}%
     \printfield{part}}
    {}%
  \newunit
  \printfield{volumes}%
  \newunit\newblock
  \usebibmacro{series+number}%
  \newunit\newblock
  \printfield{note}%
  \newunit\newblock
  \usebibmacro{publisher+location+date}%
  \newunit\newblock
  \usebibmacro{chapter+pages}%
  \usebibmacro{archive}%
  \usebibmacro{finentry}}

\def\blx@warn@bibempty{}


% hyperref
% --------
\RequirePackage[bookmarks=true,hidelinks,unicode,naturalnames]{hyperref}
\RequirePackage{bookmark}
\RequirePackage{xcolor}
\newcommand\myshade{85}
\colorlet{mylinkcolor}{violet}
\colorlet{mycitecolor}{orange!50!yellow}
\colorlet{myurlcolor}{green!50!blue}

\hypersetup{
    linkcolor  = mylinkcolor!\myshade!black,
    citecolor  = mycitecolor!\myshade!black,
    urlcolor   = myurlcolor!\myshade!black,
    colorlinks = true
}


% cleveref
% --------
\numberwithin{equation}{section}
\RequirePackage[capitalise,nameinlink]{cleveref}
\crefformat{equation}{(#2#1#3)} % equations are referenced like (1.2)
\crefformat{figure}{#2Figure #1#3} % figures are referenced like Figure 3 (not sure why the default is to use Fig.?)
\newenvironment{proofref}[1]{\begin{proof}[of \cref{#1}]}{\end{proof}}

% Format references
\crefformat{enumi}{#2#1#3}
\crefformat{equation}{(#2#1#3)}
\crefformat{theorem}{#2Theorem #1#3}
\crefformat{lemma}{#2Lemma #1#3}
\crefformat{proposition}{#2Proposition #1#3}
\crefformat{corollary}{#2Corollary #1#3}
\crefformat{claim}{#2Claim #1#3}
\crefformat{itheorem}{#2Theorem #1#3}
\crefformat{icorollary}{#2Corollary #1#3}
\crefformat{section}{#2§#1#3}
\crefformat{subsection}{#2§#1#3}
