# The Computer Language Benchmarks Game
# $Id: my.linux.Makefile,v 1.1 2012/12/29 19:19:32 igouy-guest Exp $

# ASSUME each program will build in a clean empty tmpdir
# ASSUME there's a symlink to the program source in tmpdir
# ASSUME there's a symlink to the Include directory in tmpdir
# ASSUME there are symlinks to helper files in tmpdir
# ASSUME no responsibility for removing temporary files from tmpdir

# TYPICAL actions include an initial mv to give the expected extension

# ASSUME environment variables for compilers and interpreters are set in the header


COPTS := -O3 -fomit-frame-pointer



############################################################
# ACTIONS for specific language implementations
############################################################


########################################
# java
########################################

%.java_run: %.java
	-mv $< $(TEST).java
	-$(JDKC) $(TEST).java


%.javaxint_run: %.javaxint
	-mv $< $(TEST).java
	-$(JDKC) $(TEST).java

########################################
# scala
########################################

%.scala_run: %.scala
	-mv $< $(TEST).scala
	-$(SCALAC) $(TEST).scala

########################################
# scala.js
########################################

%.scalajs_run: %.scalajs
	-$(SCALAJS_PREAMBLE) $(TEST) > $(TEST).scala
	-cat $< >> $(TEST).scala
	-$(SCALAJSC) $(TEST).scala
	-$(SCALAJSLD) -u -o $(TEST).js .
	-echo "$(TEST)_js().main()" >> $(TEST).js


########################################
# gcc
########################################

%.c: %.gcc
	-@mv $< $@

%.gcc_run: %.c
	-$(GCC) -pipe -Wall $(COPTS) $(GCCOPTS) $< -o $@ $(GCC_LINKOPTS)


########################################
# gpp
########################################

%.c++: %.gpp
	-@mv $< $@

%.gpp_run: %.c++
	-$(GXX) -c -pipe $(COPTS) $(GXXOPTS) $< -o $<.o &&  \
        $(GXX) $<.o -o $@ $(GXXLDOPTS)


