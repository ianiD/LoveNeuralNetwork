# Makefile for the LOVE NeuralNework Project
#
# You need a bash command line (use cygwin if you're on windows), make and
# moonscript on your path
#


run: moon
	love lua/ --console

moon: moon/*
	moonc -t lua moon		# Compile moonscript -> lua
	cp lua/moon/* lua/		# The code is now in lua/moon/. Copy it to lua/
	rm -r lua/moon			# Remove lua/moon/

clean:
	rm -r lua
	mkdir lua
