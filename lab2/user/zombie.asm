
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	286080e7          	jalr	646(ra) # 28e <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	280080e7          	jalr	640(ra) # 296 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	30e080e7          	jalr	782(ra) # 32e <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	19a080e7          	jalr	410(ra) # 2ae <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
  for(i=0; i+1 < max; ){
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	00000097          	auipc	ra,0x0
 16a:	170080e7          	jalr	368(ra) # 2d6 <open>
  if(fd < 0)
 16e:	02054563          	bltz	a0,198 <stat+0x42>
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	180080e7          	jalr	384(ra) # 2f6 <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	13c080e7          	jalr	316(ra) # 2be <close>
  return r;
}
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	64a2                	ld	s1,8(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	597d                	li	s2,-1
 19a:	bfc5                	j	18a <stat+0x34>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a2:	00054683          	lbu	a3,0(a0)
 1a6:	fd06879b          	addiw	a5,a3,-48
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	4625                	li	a2,9
 1b0:	02f66863          	bltu	a2,a5,1e0 <atoi+0x44>
 1b4:	872a                	mv	a4,a0
  n = 0;
 1b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b8:	0705                	addi	a4,a4,1
 1ba:	0025179b          	slliw	a5,a0,0x2
 1be:	9fa9                	addw	a5,a5,a0
 1c0:	0017979b          	slliw	a5,a5,0x1
 1c4:	9fb5                	addw	a5,a5,a3
 1c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ca:	00074683          	lbu	a3,0(a4)
 1ce:	fd06879b          	addiw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	fef671e3          	bgeu	a2,a5,1b8 <atoi+0x1c>
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  n = 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <atoi+0x3e>

00000000000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ea:	02b57463          	bgeu	a0,a1,212 <memmove+0x2e>
    while(n-- > 0)
 1ee:	00c05f63          	blez	a2,20c <memmove+0x28>
 1f2:	1602                	slli	a2,a2,0x20
 1f4:	9201                	srli	a2,a2,0x20
 1f6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fc:	0585                	addi	a1,a1,1
 1fe:	0705                	addi	a4,a4,1
 200:	fff5c683          	lbu	a3,-1(a1)
 204:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 208:	fee79ae3          	bne	a5,a4,1fc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
    dst += n;
 212:	00c50733          	add	a4,a0,a2
    src += n;
 216:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 218:	fec05ae3          	blez	a2,20c <memmove+0x28>
 21c:	fff6079b          	addiw	a5,a2,-1
 220:	1782                	slli	a5,a5,0x20
 222:	9381                	srli	a5,a5,0x20
 224:	fff7c793          	not	a5,a5
 228:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22a:	15fd                	addi	a1,a1,-1
 22c:	177d                	addi	a4,a4,-1
 22e:	0005c683          	lbu	a3,0(a1)
 232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x46>
 23a:	bfc9                	j	20c <memmove+0x28>

000000000000023c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 242:	ca05                	beqz	a2,272 <memcmp+0x36>
 244:	fff6069b          	addiw	a3,a2,-1
 248:	1682                	slli	a3,a3,0x20
 24a:	9281                	srli	a3,a3,0x20
 24c:	0685                	addi	a3,a3,1
 24e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 250:	00054783          	lbu	a5,0(a0)
 254:	0005c703          	lbu	a4,0(a1)
 258:	00e79863          	bne	a5,a4,268 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25c:	0505                	addi	a0,a0,1
    p2++;
 25e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 260:	fed518e3          	bne	a0,a3,250 <memcmp+0x14>
  }
  return 0;
 264:	4501                	li	a0,0
 266:	a019                	j	26c <memcmp+0x30>
      return *p1 - *p2;
 268:	40e7853b          	subw	a0,a5,a4
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <memcmp+0x30>

0000000000000276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27e:	00000097          	auipc	ra,0x0
 282:	f66080e7          	jalr	-154(ra) # 1e4 <memmove>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 28e:	4885                	li	a7,1
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <exit>:
.global exit
exit:
 li a7, SYS_exit
 296:	4889                	li	a7,2
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <wait>:
.global wait
wait:
 li a7, SYS_wait
 29e:	488d                	li	a7,3
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a6:	4891                	li	a7,4
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <read>:
.global read
read:
 li a7, SYS_read
 2ae:	4895                	li	a7,5
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <write>:
.global write
write:
 li a7, SYS_write
 2b6:	48c1                	li	a7,16
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <close>:
.global close
close:
 li a7, SYS_close
 2be:	48d5                	li	a7,21
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c6:	4899                	li	a7,6
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ce:	489d                	li	a7,7
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <open>:
.global open
open:
 li a7, SYS_open
 2d6:	48bd                	li	a7,15
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2de:	48c5                	li	a7,17
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e6:	48c9                	li	a7,18
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <trace>:
.global trace
trace:
 li a7, SYS_trace
 2ee:	48d9                	li	a7,22
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f6:	48a1                	li	a7,8
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <link>:
.global link
link:
 li a7, SYS_link
 2fe:	48cd                	li	a7,19
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 306:	48d1                	li	a7,20
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30e:	48a5                	li	a7,9
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <dup>:
.global dup
dup:
 li a7, SYS_dup
 316:	48a9                	li	a7,10
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31e:	48ad                	li	a7,11
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 326:	48b1                	li	a7,12
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32e:	48b5                	li	a7,13
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 336:	48b9                	li	a7,14
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 33e:	1101                	addi	sp,sp,-32
 340:	ec06                	sd	ra,24(sp)
 342:	e822                	sd	s0,16(sp)
 344:	1000                	addi	s0,sp,32
 346:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 34a:	4605                	li	a2,1
 34c:	fef40593          	addi	a1,s0,-17
 350:	00000097          	auipc	ra,0x0
 354:	f66080e7          	jalr	-154(ra) # 2b6 <write>
}
 358:	60e2                	ld	ra,24(sp)
 35a:	6442                	ld	s0,16(sp)
 35c:	6105                	addi	sp,sp,32
 35e:	8082                	ret

0000000000000360 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	7139                	addi	sp,sp,-64
 362:	fc06                	sd	ra,56(sp)
 364:	f822                	sd	s0,48(sp)
 366:	f426                	sd	s1,40(sp)
 368:	f04a                	sd	s2,32(sp)
 36a:	ec4e                	sd	s3,24(sp)
 36c:	0080                	addi	s0,sp,64
 36e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 370:	c299                	beqz	a3,376 <printint+0x16>
 372:	0805c963          	bltz	a1,404 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 376:	2581                	sext.w	a1,a1
  neg = 0;
 378:	4881                	li	a7,0
 37a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 380:	2601                	sext.w	a2,a2
 382:	00000517          	auipc	a0,0x0
 386:	49650513          	addi	a0,a0,1174 # 818 <digits>
 38a:	883a                	mv	a6,a4
 38c:	2705                	addiw	a4,a4,1
 38e:	02c5f7bb          	remuw	a5,a1,a2
 392:	1782                	slli	a5,a5,0x20
 394:	9381                	srli	a5,a5,0x20
 396:	97aa                	add	a5,a5,a0
 398:	0007c783          	lbu	a5,0(a5)
 39c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a0:	0005879b          	sext.w	a5,a1
 3a4:	02c5d5bb          	divuw	a1,a1,a2
 3a8:	0685                	addi	a3,a3,1
 3aa:	fec7f0e3          	bgeu	a5,a2,38a <printint+0x2a>
  if(neg)
 3ae:	00088c63          	beqz	a7,3c6 <printint+0x66>
    buf[i++] = '-';
 3b2:	fd070793          	addi	a5,a4,-48
 3b6:	00878733          	add	a4,a5,s0
 3ba:	02d00793          	li	a5,45
 3be:	fef70823          	sb	a5,-16(a4)
 3c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c6:	02e05863          	blez	a4,3f6 <printint+0x96>
 3ca:	fc040793          	addi	a5,s0,-64
 3ce:	00e78933          	add	s2,a5,a4
 3d2:	fff78993          	addi	s3,a5,-1
 3d6:	99ba                	add	s3,s3,a4
 3d8:	377d                	addiw	a4,a4,-1
 3da:	1702                	slli	a4,a4,0x20
 3dc:	9301                	srli	a4,a4,0x20
 3de:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e2:	fff94583          	lbu	a1,-1(s2)
 3e6:	8526                	mv	a0,s1
 3e8:	00000097          	auipc	ra,0x0
 3ec:	f56080e7          	jalr	-170(ra) # 33e <putc>
  while(--i >= 0)
 3f0:	197d                	addi	s2,s2,-1
 3f2:	ff3918e3          	bne	s2,s3,3e2 <printint+0x82>
}
 3f6:	70e2                	ld	ra,56(sp)
 3f8:	7442                	ld	s0,48(sp)
 3fa:	74a2                	ld	s1,40(sp)
 3fc:	7902                	ld	s2,32(sp)
 3fe:	69e2                	ld	s3,24(sp)
 400:	6121                	addi	sp,sp,64
 402:	8082                	ret
    x = -xx;
 404:	40b005bb          	negw	a1,a1
    neg = 1;
 408:	4885                	li	a7,1
    x = -xx;
 40a:	bf85                	j	37a <printint+0x1a>

000000000000040c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 40c:	7119                	addi	sp,sp,-128
 40e:	fc86                	sd	ra,120(sp)
 410:	f8a2                	sd	s0,112(sp)
 412:	f4a6                	sd	s1,104(sp)
 414:	f0ca                	sd	s2,96(sp)
 416:	ecce                	sd	s3,88(sp)
 418:	e8d2                	sd	s4,80(sp)
 41a:	e4d6                	sd	s5,72(sp)
 41c:	e0da                	sd	s6,64(sp)
 41e:	fc5e                	sd	s7,56(sp)
 420:	f862                	sd	s8,48(sp)
 422:	f466                	sd	s9,40(sp)
 424:	f06a                	sd	s10,32(sp)
 426:	ec6e                	sd	s11,24(sp)
 428:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42a:	0005c903          	lbu	s2,0(a1)
 42e:	18090f63          	beqz	s2,5cc <vprintf+0x1c0>
 432:	8aaa                	mv	s5,a0
 434:	8b32                	mv	s6,a2
 436:	00158493          	addi	s1,a1,1
  state = 0;
 43a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 43c:	02500a13          	li	s4,37
 440:	4c55                	li	s8,21
 442:	00000c97          	auipc	s9,0x0
 446:	37ec8c93          	addi	s9,s9,894 # 7c0 <malloc+0xf0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 44a:	02800d93          	li	s11,40
  putc(fd, 'x');
 44e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 450:	00000b97          	auipc	s7,0x0
 454:	3c8b8b93          	addi	s7,s7,968 # 818 <digits>
 458:	a839                	j	476 <vprintf+0x6a>
        putc(fd, c);
 45a:	85ca                	mv	a1,s2
 45c:	8556                	mv	a0,s5
 45e:	00000097          	auipc	ra,0x0
 462:	ee0080e7          	jalr	-288(ra) # 33e <putc>
 466:	a019                	j	46c <vprintf+0x60>
    } else if(state == '%'){
 468:	01498d63          	beq	s3,s4,482 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 46c:	0485                	addi	s1,s1,1
 46e:	fff4c903          	lbu	s2,-1(s1)
 472:	14090d63          	beqz	s2,5cc <vprintf+0x1c0>
    if(state == 0){
 476:	fe0999e3          	bnez	s3,468 <vprintf+0x5c>
      if(c == '%'){
 47a:	ff4910e3          	bne	s2,s4,45a <vprintf+0x4e>
        state = '%';
 47e:	89d2                	mv	s3,s4
 480:	b7f5                	j	46c <vprintf+0x60>
      if(c == 'd'){
 482:	11490c63          	beq	s2,s4,59a <vprintf+0x18e>
 486:	f9d9079b          	addiw	a5,s2,-99
 48a:	0ff7f793          	zext.b	a5,a5
 48e:	10fc6e63          	bltu	s8,a5,5aa <vprintf+0x19e>
 492:	f9d9079b          	addiw	a5,s2,-99
 496:	0ff7f713          	zext.b	a4,a5
 49a:	10ec6863          	bltu	s8,a4,5aa <vprintf+0x19e>
 49e:	00271793          	slli	a5,a4,0x2
 4a2:	97e6                	add	a5,a5,s9
 4a4:	439c                	lw	a5,0(a5)
 4a6:	97e6                	add	a5,a5,s9
 4a8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4aa:	008b0913          	addi	s2,s6,8
 4ae:	4685                	li	a3,1
 4b0:	4629                	li	a2,10
 4b2:	000b2583          	lw	a1,0(s6)
 4b6:	8556                	mv	a0,s5
 4b8:	00000097          	auipc	ra,0x0
 4bc:	ea8080e7          	jalr	-344(ra) # 360 <printint>
 4c0:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c2:	4981                	li	s3,0
 4c4:	b765                	j	46c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c6:	008b0913          	addi	s2,s6,8
 4ca:	4681                	li	a3,0
 4cc:	4629                	li	a2,10
 4ce:	000b2583          	lw	a1,0(s6)
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	e8c080e7          	jalr	-372(ra) # 360 <printint>
 4dc:	8b4a                	mv	s6,s2
      state = 0;
 4de:	4981                	li	s3,0
 4e0:	b771                	j	46c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4e2:	008b0913          	addi	s2,s6,8
 4e6:	4681                	li	a3,0
 4e8:	866a                	mv	a2,s10
 4ea:	000b2583          	lw	a1,0(s6)
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	e70080e7          	jalr	-400(ra) # 360 <printint>
 4f8:	8b4a                	mv	s6,s2
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bf85                	j	46c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4fe:	008b0793          	addi	a5,s6,8
 502:	f8f43423          	sd	a5,-120(s0)
 506:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 50a:	03000593          	li	a1,48
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	e2e080e7          	jalr	-466(ra) # 33e <putc>
  putc(fd, 'x');
 518:	07800593          	li	a1,120
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	e20080e7          	jalr	-480(ra) # 33e <putc>
 526:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 528:	03c9d793          	srli	a5,s3,0x3c
 52c:	97de                	add	a5,a5,s7
 52e:	0007c583          	lbu	a1,0(a5)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e0a080e7          	jalr	-502(ra) # 33e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 53c:	0992                	slli	s3,s3,0x4
 53e:	397d                	addiw	s2,s2,-1
 540:	fe0914e3          	bnez	s2,528 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 544:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 548:	4981                	li	s3,0
 54a:	b70d                	j	46c <vprintf+0x60>
        s = va_arg(ap, char*);
 54c:	008b0913          	addi	s2,s6,8
 550:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 554:	02098163          	beqz	s3,576 <vprintf+0x16a>
        while(*s != 0){
 558:	0009c583          	lbu	a1,0(s3)
 55c:	c5ad                	beqz	a1,5c6 <vprintf+0x1ba>
          putc(fd, *s);
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	dde080e7          	jalr	-546(ra) # 33e <putc>
          s++;
 568:	0985                	addi	s3,s3,1
        while(*s != 0){
 56a:	0009c583          	lbu	a1,0(s3)
 56e:	f9e5                	bnez	a1,55e <vprintf+0x152>
        s = va_arg(ap, char*);
 570:	8b4a                	mv	s6,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	bde5                	j	46c <vprintf+0x60>
          s = "(null)";
 576:	00000997          	auipc	s3,0x0
 57a:	24298993          	addi	s3,s3,578 # 7b8 <malloc+0xe8>
        while(*s != 0){
 57e:	85ee                	mv	a1,s11
 580:	bff9                	j	55e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 582:	008b0913          	addi	s2,s6,8
 586:	000b4583          	lbu	a1,0(s6)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	db2080e7          	jalr	-590(ra) # 33e <putc>
 594:	8b4a                	mv	s6,s2
      state = 0;
 596:	4981                	li	s3,0
 598:	bdd1                	j	46c <vprintf+0x60>
        putc(fd, c);
 59a:	85d2                	mv	a1,s4
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	da0080e7          	jalr	-608(ra) # 33e <putc>
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b5d1                	j	46c <vprintf+0x60>
        putc(fd, '%');
 5aa:	85d2                	mv	a1,s4
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	d90080e7          	jalr	-624(ra) # 33e <putc>
        putc(fd, c);
 5b6:	85ca                	mv	a1,s2
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	d84080e7          	jalr	-636(ra) # 33e <putc>
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b565                	j	46c <vprintf+0x60>
        s = va_arg(ap, char*);
 5c6:	8b4a                	mv	s6,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b54d                	j	46c <vprintf+0x60>
    }
  }
}
 5cc:	70e6                	ld	ra,120(sp)
 5ce:	7446                	ld	s0,112(sp)
 5d0:	74a6                	ld	s1,104(sp)
 5d2:	7906                	ld	s2,96(sp)
 5d4:	69e6                	ld	s3,88(sp)
 5d6:	6a46                	ld	s4,80(sp)
 5d8:	6aa6                	ld	s5,72(sp)
 5da:	6b06                	ld	s6,64(sp)
 5dc:	7be2                	ld	s7,56(sp)
 5de:	7c42                	ld	s8,48(sp)
 5e0:	7ca2                	ld	s9,40(sp)
 5e2:	7d02                	ld	s10,32(sp)
 5e4:	6de2                	ld	s11,24(sp)
 5e6:	6109                	addi	sp,sp,128
 5e8:	8082                	ret

00000000000005ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5ea:	715d                	addi	sp,sp,-80
 5ec:	ec06                	sd	ra,24(sp)
 5ee:	e822                	sd	s0,16(sp)
 5f0:	1000                	addi	s0,sp,32
 5f2:	e010                	sd	a2,0(s0)
 5f4:	e414                	sd	a3,8(s0)
 5f6:	e818                	sd	a4,16(s0)
 5f8:	ec1c                	sd	a5,24(s0)
 5fa:	03043023          	sd	a6,32(s0)
 5fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 602:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 606:	8622                	mv	a2,s0
 608:	00000097          	auipc	ra,0x0
 60c:	e04080e7          	jalr	-508(ra) # 40c <vprintf>
}
 610:	60e2                	ld	ra,24(sp)
 612:	6442                	ld	s0,16(sp)
 614:	6161                	addi	sp,sp,80
 616:	8082                	ret

0000000000000618 <printf>:

void
printf(const char *fmt, ...)
{
 618:	711d                	addi	sp,sp,-96
 61a:	ec06                	sd	ra,24(sp)
 61c:	e822                	sd	s0,16(sp)
 61e:	1000                	addi	s0,sp,32
 620:	e40c                	sd	a1,8(s0)
 622:	e810                	sd	a2,16(s0)
 624:	ec14                	sd	a3,24(s0)
 626:	f018                	sd	a4,32(s0)
 628:	f41c                	sd	a5,40(s0)
 62a:	03043823          	sd	a6,48(s0)
 62e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 632:	00840613          	addi	a2,s0,8
 636:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 63a:	85aa                	mv	a1,a0
 63c:	4505                	li	a0,1
 63e:	00000097          	auipc	ra,0x0
 642:	dce080e7          	jalr	-562(ra) # 40c <vprintf>
}
 646:	60e2                	ld	ra,24(sp)
 648:	6442                	ld	s0,16(sp)
 64a:	6125                	addi	sp,sp,96
 64c:	8082                	ret

000000000000064e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64e:	1141                	addi	sp,sp,-16
 650:	e422                	sd	s0,8(sp)
 652:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 654:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	00000797          	auipc	a5,0x0
 65c:	1d87b783          	ld	a5,472(a5) # 830 <freep>
 660:	a02d                	j	68a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 662:	4618                	lw	a4,8(a2)
 664:	9f2d                	addw	a4,a4,a1
 666:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 66a:	6398                	ld	a4,0(a5)
 66c:	6310                	ld	a2,0(a4)
 66e:	a83d                	j	6ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 670:	ff852703          	lw	a4,-8(a0)
 674:	9f31                	addw	a4,a4,a2
 676:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 678:	ff053683          	ld	a3,-16(a0)
 67c:	a091                	j	6c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	6398                	ld	a4,0(a5)
 680:	00e7e463          	bltu	a5,a4,688 <free+0x3a>
 684:	00e6ea63          	bltu	a3,a4,698 <free+0x4a>
{
 688:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	fed7fae3          	bgeu	a5,a3,67e <free+0x30>
 68e:	6398                	ld	a4,0(a5)
 690:	00e6e463          	bltu	a3,a4,698 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	fee7eae3          	bltu	a5,a4,688 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 698:	ff852583          	lw	a1,-8(a0)
 69c:	6390                	ld	a2,0(a5)
 69e:	02059813          	slli	a6,a1,0x20
 6a2:	01c85713          	srli	a4,a6,0x1c
 6a6:	9736                	add	a4,a4,a3
 6a8:	fae60de3          	beq	a2,a4,662 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6b0:	4790                	lw	a2,8(a5)
 6b2:	02061593          	slli	a1,a2,0x20
 6b6:	01c5d713          	srli	a4,a1,0x1c
 6ba:	973e                	add	a4,a4,a5
 6bc:	fae68ae3          	beq	a3,a4,670 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6c2:	00000717          	auipc	a4,0x0
 6c6:	16f73723          	sd	a5,366(a4) # 830 <freep>
}
 6ca:	6422                	ld	s0,8(sp)
 6cc:	0141                	addi	sp,sp,16
 6ce:	8082                	ret

00000000000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	7139                	addi	sp,sp,-64
 6d2:	fc06                	sd	ra,56(sp)
 6d4:	f822                	sd	s0,48(sp)
 6d6:	f426                	sd	s1,40(sp)
 6d8:	f04a                	sd	s2,32(sp)
 6da:	ec4e                	sd	s3,24(sp)
 6dc:	e852                	sd	s4,16(sp)
 6de:	e456                	sd	s5,8(sp)
 6e0:	e05a                	sd	s6,0(sp)
 6e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e4:	02051493          	slli	s1,a0,0x20
 6e8:	9081                	srli	s1,s1,0x20
 6ea:	04bd                	addi	s1,s1,15
 6ec:	8091                	srli	s1,s1,0x4
 6ee:	0014899b          	addiw	s3,s1,1
 6f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6f4:	00000517          	auipc	a0,0x0
 6f8:	13c53503          	ld	a0,316(a0) # 830 <freep>
 6fc:	c515                	beqz	a0,728 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 700:	4798                	lw	a4,8(a5)
 702:	02977f63          	bgeu	a4,s1,740 <malloc+0x70>
 706:	8a4e                	mv	s4,s3
 708:	0009871b          	sext.w	a4,s3
 70c:	6685                	lui	a3,0x1
 70e:	00d77363          	bgeu	a4,a3,714 <malloc+0x44>
 712:	6a05                	lui	s4,0x1
 714:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 718:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 71c:	00000917          	auipc	s2,0x0
 720:	11490913          	addi	s2,s2,276 # 830 <freep>
  if(p == (char*)-1)
 724:	5afd                	li	s5,-1
 726:	a895                	j	79a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 728:	00000797          	auipc	a5,0x0
 72c:	11078793          	addi	a5,a5,272 # 838 <base>
 730:	00000717          	auipc	a4,0x0
 734:	10f73023          	sd	a5,256(a4) # 830 <freep>
 738:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 73a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 73e:	b7e1                	j	706 <malloc+0x36>
      if(p->s.size == nunits)
 740:	02e48c63          	beq	s1,a4,778 <malloc+0xa8>
        p->s.size -= nunits;
 744:	4137073b          	subw	a4,a4,s3
 748:	c798                	sw	a4,8(a5)
        p += p->s.size;
 74a:	02071693          	slli	a3,a4,0x20
 74e:	01c6d713          	srli	a4,a3,0x1c
 752:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 754:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 758:	00000717          	auipc	a4,0x0
 75c:	0ca73c23          	sd	a0,216(a4) # 830 <freep>
      return (void*)(p + 1);
 760:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 764:	70e2                	ld	ra,56(sp)
 766:	7442                	ld	s0,48(sp)
 768:	74a2                	ld	s1,40(sp)
 76a:	7902                	ld	s2,32(sp)
 76c:	69e2                	ld	s3,24(sp)
 76e:	6a42                	ld	s4,16(sp)
 770:	6aa2                	ld	s5,8(sp)
 772:	6b02                	ld	s6,0(sp)
 774:	6121                	addi	sp,sp,64
 776:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 778:	6398                	ld	a4,0(a5)
 77a:	e118                	sd	a4,0(a0)
 77c:	bff1                	j	758 <malloc+0x88>
  hp->s.size = nu;
 77e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 782:	0541                	addi	a0,a0,16
 784:	00000097          	auipc	ra,0x0
 788:	eca080e7          	jalr	-310(ra) # 64e <free>
  return freep;
 78c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 790:	d971                	beqz	a0,764 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 794:	4798                	lw	a4,8(a5)
 796:	fa9775e3          	bgeu	a4,s1,740 <malloc+0x70>
    if(p == freep)
 79a:	00093703          	ld	a4,0(s2)
 79e:	853e                	mv	a0,a5
 7a0:	fef719e3          	bne	a4,a5,792 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7a4:	8552                	mv	a0,s4
 7a6:	00000097          	auipc	ra,0x0
 7aa:	b80080e7          	jalr	-1152(ra) # 326 <sbrk>
  if(p == (char*)-1)
 7ae:	fd5518e3          	bne	a0,s5,77e <malloc+0xae>
        return 0;
 7b2:	4501                	li	a0,0
 7b4:	bf45                	j	764 <malloc+0x94>
