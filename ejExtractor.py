import sys
import getopt
import os
import shutil


def help():
	print "USAGE : ejExtractor.py -[Option] [Path]"
	print "USAGE2 (Powershell Secure String) : ejExtractor.py -[Option] [Path] -key [key]"
	print "==== Option ===="
	print "-l : AutoHotKey version L"
	print "-b : AutoHotKey version B"
	print "-A : AutoIt Simple Way"
	print "-a : AutoIt Another Way"
	print "-i : InnoSetup"
	print "-n : NSIS"
	print "-m : MSI"
	print "-pdd : Powershell Deflate Decode"
	print "-pde : Powershell Deflate Encode"
	print "-pgd : Powershell GZip Decode"
	print "-pge : Powershell GZip Encode"
	print "-pse : Powershell Secure String Decode"
	print "-psd : Powershell Secure String Encode"
	print "-jve : JS/VBS Encoding"
	print "-jvd : JSE/VBE Eecoding"
	return

  
def find_nth(s, x, n, i = 0):
    i = s.find(x, i)
    if n == 1 or i == -1:
        return i 
    else:
        return find_nth(s, x, n - 1, i + len(x))
  
 
def main():
	
	if len(sys.argv) <= 2:
		help()
		return
	
	opt = sys.argv[1]


	nowDir = os.path.dirname(sys.argv[0])
	os.chdir(nowDir)
	resDir = os.path.dirname(sys.argv[2])
	resNameWith = os.path.basename(sys.argv[2])
	resName = os.path.splitext(resNameWith)[0] + "_"
	res = resDir + "\\" + resName
	os.makedirs(res)
 

	if ( opt == "-l" ):
	# autohotkey_L
		f=sys.argv[2]
		resFile = res + "\\result.txt"
		f=open(f,'rb')
		f=f.read()
		n=f.find('\x3cCOMPILER:')
		f=f[n:]
		n=f.find('\x00\x00')
		f=f[0:n]
		f=f.replace('\x0a','\x0d\x0a')
		q=open(resFile,'wb')
		q.write(f)
		q.close()
	elif ( opt == "-b" ):
	# autohotkey_B
		os.chdir('AutoHK')
		autohkDir = os.getcwd()
		exe2ahkFile = autohkDir + "\\AutoHK_B.exe"
		itsTemp = res + "\\AutoHK_B.exe"
		itsTemp2 = res + "\\dumb.exe"
		shutil.copy(exe2ahkFile, itsTemp)
		shutil.copy(sys.argv[2], itsTemp2)
		command = itsTemp + " " + itsTemp2
		os.system(command)
		os.remove(itsTemp)
		os.remove(itsTemp2)
	elif ( opt == "-a" ):
	# AutoIt
		os.chdir('AutoIt')
		autoitDir = os.getcwd()
		inputFile = sys.argv[2]
		compiledscript = autoitDir + "\\compiledScript.bin"
		dumbFile = autoitDir + "\\dumb.bin"
		exe2autFile = autoitDir + "\\Exe2Aut.exe"
		dumbbackFile = autoitDir + "\\dumb.bin.backup"
		
		fr = open(inputFile, "rb")
		# For read input file
		fs = open(compiledscript, "wb")
		# For output compiled script file
		fd = open(dumbFile, "ab")

		# Read input file and Extract Compiled script
		readInput = fr.read()

		startAddr = find_nth(readInput, "AU3!EA06", 1) - 16
		endAddr = find_nth(readInput, "AU3!EA06", 2) + 8

		fs.write(readInput[startAddr:endAddr])
		fs.close()

		# Read compiled script file
		fs = open(compiledscript, "rb")
		r2 = fs.read()

		# Append compiled script file to dumb.bin
		fd.write(r2)

		fr.close()
		fs.close()
		fd.close()
		
		itsTemp = res + "\\Exe2Aut.exe"
		itsTemp2 = res + "\\dumb.bin"
		shutil.copy(exe2autFile, itsTemp)
		shutil.copy(dumbFile, itsTemp2)
		
		command = itsTemp + " -nogui -quiet " + itsTemp2
		os.system(command)
		
		os.remove(itsTemp)
		os.remove(itsTemp2)
		os.remove(compiledscript)
		os.remove(dumbFile)
		shutil.copy(dumbbackFile, dumbFile)
	elif ( opt == "-A"):
	# AutoIt Just
		os.chdir('AutoIt' )
		autoitDir = os.getcwd()
		inputFile = sys.argv[2]
		exe2autFile = autoitDir + "\\Exe2Aut.exe"
		itsTemp = res + "\\Exe2Aut.exe"
		itsTemp2 = res + "\\dumb.exe"
		shutil.copy(exe2autFile, itsTemp)
		shutil.copy(sys.argv[2], itsTemp2)
		command = itsTemp + " -nogui -quiet " + itsTemp2
		os.system(command)
		os.remove(itsTemp)
		os.remove(itsTemp2)
	elif ( opt == "-i" ):
	# InnoSetup
		os.chdir('InnoSetup')
		innoDir = os.getcwd()
		innoFile = innoDir + "\\innounp47.exe"
		command = innoFile + " -x " + sys.argv[2]
		os.chdir(res)
		os.system(command)
	elif ( opt == "-n" ):
	# NSIS
		os.chdir('NSIS')
		nsisDir = os.getcwd()
		nsisFile = nsisDir + "\\7z.exe"
		command = nsisFile + " e " + sys.argv[2]
		os.chdir(res)
		os.system(command)
	elif ( opt == "-m" ):
	# MSI
		os.chdir('MSI')
		msiDir = os.getcwd()
		msiFile = msiDir + "\\jsMSIx.exe"
		msiTemp = res + "\\temp.msi"
		shutil.copy(sys.argv[2], msiTemp)
		command = msiFile + " " + msiTemp
		os.system(command)
		os.remove(msiTemp)
	elif ( opt == "-pdd" ):
	# Powershell Deflate Decode
		os.chdir('Powershell')
		pshDir = os.getcwd()
		pshFile = pshDir + '\\PshCodec.ps1'
		pshTemp = res + "\\temp.ps1"
		shutil.copy(sys.argv[2], pshTemp)
		command = "powershell.exe -executionpolicy bypass " + pshFile + " DeflateDecode " + pshTemp
		os.chdir(res)
		print resDir
		os.system(command)
		os.remove(pshTemp)
	elif ( opt == "-pde" ):
	# Powershell Deflate Encode
		os.chdir('Powershell')
		pshDir = os.getcwd()
		pshFile = pshDir + '\\PshCodec.ps1'
		pshTemp = res + "\\temp.ps1"
		shutil.copy(sys.argv[2], pshTemp)
		command = "powershell.exe -executionpolicy bypass " + pshFile + " DeflateEncode " + pshTemp
		os.chdir(res)
		print resDir
		os.system(command)
		os.remove(pshTemp)
	elif ( opt == "-pgd" ):
	# Powershell Gzip Decode
		os.chdir('Powershell')
		pshDir = os.getcwd()
		pshFile = pshDir + '\\PshCodec.ps1'
		pshTemp = res + "\\temp.ps1"
		shutil.copy(sys.argv[2], pshTemp)
		command = "powershell.exe -executionpolicy bypass " + pshFile + " GzipDecode " + pshTemp
		os.chdir(res)
		print resDir
		os.system(command)
		os.remove(pshTemp)
	elif ( opt == "-pge" ):
	# Powershell Gzip Encode
		os.chdir('Powershell')
		pshDir = os.getcwd()
		pshFile = pshDir + '\\PshCodec.ps1'
		pshTemp = res + "\\temp.ps1"
		shutil.copy(sys.argv[2], pshTemp)
		command = "powershell.exe -executionpolicy bypass " + pshFile + " GzipEncode " + pshTemp
		os.chdir(res)
		print resDir
		os.system(command)
		os.remove(pshTemp)
	elif ( opt == "-psd" ):
	# Powershell Secure String Decode
		if sys.argv[3] != '-key':
			print 'error'
			return
		os.chdir('Powershell')
		pshDir = os.getcwd()
		pshFile = pshDir + '\\PshCodec.ps1'
		pshTemp = res + "\\temp.ps1"
		shutil.copy(sys.argv[2], pshTemp)
		command = "powershell.exe -executionpolicy bypass " + pshFile + " SecureDecode " + pshTemp + " " + sys.argv[4]
		os.chdir(res)
		print resDir
		os.system(command)
		os.remove(pshTemp)
	elif ( opt == "-pse" ):
	# Powershell Secure String Encode
		if sys.argv[3] != '-key':
			print 'error'
			return
		os.chdir('Powershell')
		pshDir = os.getcwd()
		pshFile = pshDir + '\\PshCodec.ps1'
		pshTemp = res + "\\temp.ps1"
		shutil.copy(sys.argv[2], pshTemp)
		command = "powershell.exe -executionpolicy bypass " + pshFile + " SecureEncode " + pshTemp + " " + sys.argv[4]
		os.chdir(res)
		print resDir
		os.system(command)
		os.remove(pshTemp)
	elif ( opt == "-jve" ):
	# JS/VBS Encoding
		os.chdir('JV')
		jvDir = os.getcwd()
		jvFile = jvDir + "\\Encode.vbs"
		jvTemp = res + "\\temp.vbs"
		shutil.copy(sys.argv[2], jvTemp)
		command = jvFile + " " + jvTemp
		os.system(command)
		os.remove(jvTemp)
	elif ( opt == "-jvd" ):
	# JSE/VBE Decoding
		os.chdir('JV')
		jvDir = os.getcwd()
		jvFile = jvDir + "\\Decode.vbs"
		jvTemp = res + "\\temp.vbe"
		shutil.copy(sys.argv[2], jvTemp)
		command = jvFile + " " + jvTemp
		os.system(command)
		os.remove(jvTemp)
 

	return
 
 
if __name__ == '__main__':
	main()
