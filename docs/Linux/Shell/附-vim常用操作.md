# 附-vim常用操作

vi编辑器是Linux上最常用的编辑器，很多Linux发行版都默认安装了vi。其中，vi这个名称是visual interface的缩写。vi拥有非常多的命令，但是正因为有非常多的命令，才使得vi的功能非常灵活和强大。在一般的Shell编程和系统维护中，vi已经完全够用了。下面详细介绍vi编辑器的使用方法，主要包括vi的使用模式、文件的打开、关闭和保存、插入文本或者新建行、移动光标、删除、恢复字符或者行，以及搜索等。

通常认为，vi有3种使用模式，分别为

- 一般模式
- 编辑模式
- 命令模式。

在每种模式下面，用户都可以分别执行不同的操作。例如，在一般模式下，用户可以进行光标位置的移动、删除字符，以及复制等；在编辑模式下，用户可以插入字符或者删除字符等；

在命令模式下，用户可以保存文件或者退出编辑器等。


下面将分别介绍这3种模式的使用方法。




## 1.一般模式

### 1.1 光标移动快捷键


|操作|快捷键|说明|
|---|---|---|
|向下移动光标|	向下方向键、j键或者空格键|	每按1次键，光标向正下方移动1行|
|向上移动光标|	向上方向键、k键或者backspace键|	每按1次键，光标向正上方移动1行|
|向左移动光标|	向左方向键或者h键|	每按1次键，光标向左移动过1个字符|
|向右移动光标|	向右方向键或者l键|	每按1次键，光标向右移动1个字符|
|移至下1行行首|	回车键|	每按1次键，光标会移动到下1行的行首|
|移至上1行行首|	-键|	每按1次键，光标会移动到上1行的行首|
|移至文件最后1行|	G键|	将光标移动到文件最后1行的行首|



### 1.2 文本操作快捷键

|操作|快捷键|说明|
|---|---|---|
|右插入	|a|	在当前光标所处位置的右边插入文本|
|左插入	|i|	在当前光标所处位置的左边插入文本|
|行尾追加	|A|	在当前行的末尾追加文本|
|行首插入	|I|	在当前行的开始处插入文本|
|插入行	|O或者o|	O键在当前行的上面插入一个新行，o键将在当前行的下面插入一个新行|
|覆盖文本	|R|	覆盖当前光标所在的位置以及后面的若干文本|
|合并行	|J|	将当前光标所在行与下面的一行合并为一行|



### 1.3 文本复制和粘贴快捷键

|操作|快捷键|说明|
|---|---|---|
|复制行|	yy	|将当前行复制到缓冲区。如果想要定义多个缓冲区，可以使用ayy、byy以及cyy语法。其中yy前面的字符表示缓冲区的名称，可以是任意单个字母。这样的话，可以将多个单独的行复制到多个缓冲区中，各个缓冲区相互之间不受影响|
|复制多行|	nyy|	将当前行以及下面的n行复制到缓冲区，其中n表示一个整数。与yy命令相似，用户也可以使用anyy或者bnyy等语法来命名缓冲区|
|复制单词|yw |复制从光标当前位置到当前单词词尾的字符|
|复制多个单词|	nyw|	其中n是一个整数，表示从光标当前位置开始，复制后面的n个单词|
|复制光标到行首|	y^|	从当前光标所处的位置开始，复制到当前行的行首|
|复制光标到行尾|	y$|	从当前光标所处的位置开始，复制到当前行的行尾|
|粘贴到光标后面的位置|	p|	将缓冲区中的字符串插入点当前光标所处位置的后面。如果定义了多个缓冲区，则使用ap方式来粘贴，其中字母a表示缓冲区的名称|
|粘贴到光标前面的位置|	P|	将将缓冲区中的字符串插入到当前光标所处位置的前面。如果定义了多个缓冲区，则使用aP的方式来粘贴，其中字母a表示缓冲区的名称|



### 1.4 删除文本快捷键

|操作|快捷键|说明|
|---|---|---|
|删除当前字符|	x	|删除光标所在的位置的字符|
|删除多个字符|	nx|	删除从光标所在位置开始，后面的n个字符|
|删除当前行|	dd	|删除光标所处的整个行|
|删除多个行|	n dd|	删除包括当前行在内的n行|
|撤销上一步操作|	u|	撤销刚刚执行的操作|
|撤销多个操作|	U	|撤销针对当前行的所有操作|


其中最常用的操作就是删除当前的字符和删除当前行，这两个操作分别由快捷键x和dd完成。


## 2.编辑模式

vi的编辑模式与其他编辑器的编辑模式没有太大的区别。在编辑模式下，用户可以使用上、下、左和右4个方向键移动光标，使用backspace键和del来删除光标前面的字符，还可以在光标所在的位置插入字符。

> 注意： 在编辑模式下，用户不能使用h、j、k和l这4个键移动光标，也不能使用x键删除字符。因为在编辑模式下，这些字母都被当做是正常的字母。



## 3.命令模式

命令模式也是使用比较多的一种模式，在命令模式下，用户主要完成文件的打开、保存、将光标跳转到某行，以及显示行号等操作。

下面将分别详细介绍这些功能。vi的命令模式需要从一般模式进入，当用户在一般模式下，按冒号键“:”之后，会在vi编辑界面的底部出现命令提示符。


|操作|快捷键|说明|
|---|---|---|
|打开文件|	:e|	打开另外一个文件，将文件名作为参数|
|保存文件|	:w|	保存文件，即将文件的改动写入磁盘。如果将文件另存为其他文件名，则可以将新的文件名作为参数|
|退出编辑器|	:q|	退出vi编辑器|
|直接退出编辑器|	:q!|	不保存修改，直接退出vi编辑器|
|退出并保存文件|	:wq|	将文件保存后退出vi编辑器|



### 3.1 常用的其他命令

|操作|快捷键|说明|
|---|---|---|
|跳至指定行	|:n、:n +或者:n| -	:n表示跳到行号为n的行，:n+表示向下跳n行，:n-表示向上跳n行|
|显示或者隐藏行号|	:set nu或者:set nonu|	:set nu表示在每行的前面显示行号；:set nonu表示隐藏行号|
|替换字符串|	:s/old/new<br>:s/old/new/g、<br>:n,m s/old/new/g或者:%s/old/new/g| :s/old/new表示用字符串new替换当前行中首次出现的字符串old；<br>:s/old/new/g表示用字符new替换当前行中所有的字符串old；<br>:n,m s/old/new/g表示用字符串new替换从n行到m行所有的字符串old；<br>:%s/old/new/g表示用字符串new替换当前文件中所有的字符串old|
|设置文件格式|	:set fileformat=unix	|将文件修改为unix格式，如win下面的文本文件在linux下会出现^M。其中fileformat可以取unix或者dos等值|




## 4.配置文件.vimrc的重要参数


推荐使用此配置 如下：

```shell
[root@oldboy ~]# cat .vimrc-nozhushi
set nocompatible
set history=100
filetype on
filetype plugin on
filetype indent on
set autoread
set mouse=a
syntax enable
set cursorline
hi cursorline guibg=#00ff00
hi CursorColumn guibg=#00ff00
set nofen
set fdl=0
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set ai
set si
set wrap
set sw=4
set wildmenu
set ruler
set cmdheight=1
set lz
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set magic
set noerrorbells
set novisualbell
set showmatch
set mat=2
set hlsearch
set ignorecase
set encoding=utf-8
set fileencodings=utf-8
set termencoding=utf-8
set smartindent
set cin
set showmatch
set guioptions-=T
set guioptions-=m
set vb t_vb=
set laststatus=2
set pastetoggle=<F9>
set background=dark
highlight Search ctermbg=black  ctermfg=white guifg=white guibg=black
autocmd BufNewFile *.py,*.cc,*.sh,*.java exec ":call SetTitle()"
func SetTitle()
    if expand("%:e") == 'sh'
        call setline(1, "#!/bin/bash")
        call setline(2, "#Author:oldboy")
        call setline(3, "#Blog:http://oldboy.blog.51cto.com")
        call setline(4, "#Time:".strftime("%F %T"))
        call setline(5, "#Name:".expand("%"))
        call setline(6, "#Version:V1.0")
        call setline(7, "#Description:This is a test script.")
    endif
endfunc
```


vim路径等配置知识

|相关配置文件|功能描述|
|------|------|
|.viminfo|用户使用vim的操作历史|
|.vimrc|用户使用vim的配置文件|
|/etc/vimrc|系统全局vim的配置文件|
|/usr/share/vim/vim74/colors|配色模板文件存放路径|

