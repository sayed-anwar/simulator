from shutil import copyfile
import sys

def test():
	print ('python: Start of script execution.')	
	copyfile(sys.argv[1], sys.argv[2])
	copyfile(sys.argv[1], sys.argv[3])
	print ('python: End of script execution.')
if __name__ == '__main__':
	test()