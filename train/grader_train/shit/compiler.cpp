#include <sys/types.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>


int compile_time_limit; 	// seconds
char compiler[16];

int do_restrict() {
	struct rlimit rl;

    rl.rlim_max = rl.rlim_cur = compile_time_limit;
    if ( setrlimit(RLIMIT_CPU,&rl) == -1 ) {
		printf("ERROR\n");
		return 0;
    }
    
	return 1;
}

int redirect_compiler_output(char *lang) {
	printf("Here\n");
	char *compiler_output_file = "./tmp/compile.error.txt";
	
	int output = open(compiler_output_file, O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
	if (output == -1) {
		printf("output file open error (%s)", strerror(errno));
		return 0;
	}
	
	if ( strcmp(lang,"fpc")==0 ) {
		if (dup2(output, STDOUT_FILENO) != STDOUT_FILENO) {
			printf("dup2 error to stdout (%s)", strerror(errno));
			return 0;
		}
	} else {
		if (dup2(output, STDERR_FILENO) != STDERR_FILENO) {
			printf("dup2 error to stdout (%s)", strerror(errno));
			return 0;
		}
	}
	return 1;
}


int main(int argc, char *argv[]) {
	
/*	if ( argc != 3 ) {
		printf("wrong number of arguments error\n");
		return -1;
	}
*/
	
//	printf("Start execution\n");	
	compile_time_limit = atoi(argv[1]);
	struct rusage rusage;
	struct stat file_stat;
	int status = 0, pid = 0;
	
	if ( (pid = fork()) < 0 ) {
		printf("fork error\n");
		return -1;
	}
	
	if ( pid==0 ) {
		int res=1;

		res = redirect_compiler_output(argv[2]);
		
		if ( res == 0 ) {
			printf("redirect IO error\n");
		}
		
		res = do_restrict();

		if ( res == 0 ) {
			printf("restriction error\n");
		}
//		printf("%s\n",argv[4]);
		// Da si go oprawq
		if ( execlp(argv[2], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8], argv[9], NULL) < 0 ) {
			printf("execl ERROR(run) (%s)\n", strerror(errno)); 
		}
		return 0;		
		
	} else {
		
		if (wait4(pid, &status, 0, &rusage) < 0) {
			printf("wait error\n");
			return -1;
		}
		
		int sig = WTERMSIG(status);
		int exit_status = WEXITSTATUS(status);
		
		int run_time = 0;
		
//		printf("%d %d\n\n",rusage.ru_utime.tv_sec,rusage.ru_utime.tv_usec);
		run_time = (rusage.ru_utime.tv_sec + rusage.ru_stime.tv_sec) *1000 + (rusage.ru_utime.tv_usec + rusage.ru_stime.tv_usec) / 1000;
		
		char res[1024] = "responce:";
		
		switch ( sig ) {
			case SIGXCPU:
			case SIGKILL:
				strcat(res,"compile_time_limit_exceeded\n"); break;
			case 0: if (stat(argv[4], &file_stat) < 0)  {
					if (errno == ENOENT)
						{
							printf("compile FAIL\n");
						}`
					strcat(res,"compiler_errors\n");
					break;
				}				
			default:
				strcat(res,"unknown_compiletion_error\n");
		}

		char buf[128] = "";
		
		sprintf(buf,"user_time:%d\n",rusage.ru_utime.tv_sec*1000+rusage.ru_utime.tv_usec/1000);
		strcat(res,buf);

		sprintf(buf,"system_time:%d\n",rusage.ru_stime.tv_sec*1000+rusage.ru_stime.tv_usec/1000);
		strcat(res,buf);

/*		sprintf(buf,"memory_usage_idrss:%ld\n",rusage.ru_idrss);
		strcat(res,buf);
		
		sprintf(buf,"memory_usage_isrss:%ld\n",rusage.ru_isrss);
		strcat(res,buf);
		
		sprintf(buf,"memory_usage_ixrss:%ld\n",rusage.ru_ixrss);
		strcat(res,buf);
		
		sprintf(buf,"memory_usage_maxrss:%ld\n",rusage.ru_maxrss);
		strcat(res,buf);*/		
					
		freopen("compiler.log","w",stdout);
		printf("%s",res);		
	}	    
}
