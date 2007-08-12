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

int time_limit; 	// miliseconds
int mem_limit;		//MB
int output_limit;	//MB

int do_restrict() {
	struct rlimit rl;

    rl.rlim_max = rl.rlim_cur = time_limit/1000;
    if ( setrlimit(RLIMIT_CPU,&rl) == -1 ) {
		printf("ERROR\n");
		return 0;
    }

    rl.rlim_max = rl.rlim_cur = mem_limit*1024*1024;
    if ( setrlimit(RLIMIT_AS,&rl) == -1 ) {
		printf("ERROR\n");
		return 0;
    }
    
    rl.rlim_max = rl.rlim_cur = output_limit*1024;
    if ( setrlimit(RLIMIT_FSIZE,&rl) == -1 ) {
		printf("ERROR\n");
		return 0;
    }

    rl.rlim_max = rl.rlim_cur = 4;
    if ( setrlimit(RLIMIT_NPROC,&rl) == -1 ) {
		printf("ERROR\n");
		return 0;
    }
    
    int res = 0;
    res = chroot("./box");
    if (res == -1) {
		printf("chroot ERROR\n (%s)", strerror(errno)); 
        return 0;
    }

    res = chdir("./box");
    if (res == -1) {
		printf("chdir ERROR\n (%s)", strerror(errno));
        return 0;
    }

    res = setuid(1001);
    if (res == -1) {
        printf("setuid ERROR\n");
        return 0;
    }
   
	return 1;
}

int redirect_io() {
	char *input_file = "./box/in";
	char *output_file = "./box/out";
	
	int input = open(input_file, O_RDONLY);
	if (input == -1) {
		printf("input file open error(%s) (%s)", input_file, strerror(errno));
		return 0;
	}
	
	int output = open(output_file, O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
	if (output == -1) {
		printf("output file open error (%s)", strerror(errno));
		return 0;
	}
	
	if (dup2(input, STDIN_FILENO) != STDIN_FILENO) {
		printf("dup2 error to stdin (%s)", strerror(errno));
		return 0;
	}

	if (dup2(output, STDOUT_FILENO) != STDOUT_FILENO) {
		printf("dup2 error to stdout (%s)", strerror(errno));
		return 0;
	}
	return 1;
}


int main(int argc, char *argv[]) {
	
	if ( argc != 4 ) {
		printf("wrong number of arguments error\n");
		return -1;
	}
	
//	printf("Start execution\n");	
	time_limit = atoi(argv[1]);
	mem_limit = atoi(argv[2]);
	output_limit = atoi(argv[3]);
	struct rusage rusage;
	int status = 0, pid = 0;
	

	
	if ( (pid = fork()) < 0 ) {
		printf("fork error\n");
		return -1;
	}
	
	if ( pid==0 ) {
		int res;

		res = redirect_io();
		
		if ( res == 0 ) {
			printf("redirect IO error\n");
		}
		
		res = do_restrict();

		if ( res == 0 ) {
			printf("restriction error\n");
		}
		
		if ( execl("tmp", "tmp", NULL) < 0 ) {
			printf("execl ERROR(run) (%s)\n", strerror(errno)); 
		}
		return 0;		
		
	} else {
		
		if (wait4(pid, &status, 0, &rusage) < 0) {
			printf("wait error\n");
			return -1;
		}
		
//		printf("Execution Over\n");
		int sig = WTERMSIG(status);
		int exit_status = WEXITSTATUS(status);
		
		int run_time = 0;
		
//		printf("%d %d\n\n",rusage.ru_utime.tv_sec,rusage.ru_utime.tv_usec);
		run_time = (rusage.ru_utime.tv_sec + rusage.ru_stime.tv_sec) *1000 + (rusage.ru_utime.tv_usec + rusage.ru_stime.tv_usec) / 1000;
		
		char res[1024] = "responce:";
		
		if ( run_time > time_limit ) {
			strcat(res,"time_limit\n");
		} else if ( exit_status!=0 ) {
			strcat(res,"exit_coder_not_zero\n");
		} else {			
			
			switch ( sig ) {
				case SIGXCPU:
				case SIGKILL:
					strcat(res,"execution_error\n"); break;
				case SIGSEGV:
					strcat(res,"execution_error_invalid_memory_reference\n"); break;
				case SIGXFSZ:
					strcat(res,"output_limit_exceeded\n"); break;
				case 0:
					strcat(res,"ok\n"); break;
				default:
					strcat(res,"unknown_execution_error\n");					
			}
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
					
		freopen("log","w",stdout);
		printf("%s",res);		
	}	    
}
