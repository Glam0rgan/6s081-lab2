
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d44c>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x22d6>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd61b>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	67850513          	addi	a0,a0,1656 # 16d8 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	df8080e7          	jalr	-520(ra) # e88 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	27e50513          	addi	a0,a0,638 # 1318 <malloc+0xe6>
      a2:	00001097          	auipc	ra,0x1
      a6:	dc6080e7          	jalr	-570(ra) # e68 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	26e50513          	addi	a0,a0,622 # 1318 <malloc+0xe6>
      b2:	00001097          	auipc	ra,0x1
      b6:	dbe080e7          	jalr	-578(ra) # e70 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	26450513          	addi	a0,a0,612 # 1320 <malloc+0xee>
      c4:	00001097          	auipc	ra,0x1
      c8:	0b6080e7          	jalr	182(ra) # 117a <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d2a080e7          	jalr	-726(ra) # df8 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	26a50513          	addi	a0,a0,618 # 1340 <malloc+0x10e>
      de:	00001097          	auipc	ra,0x1
      e2:	d92080e7          	jalr	-622(ra) # e70 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	26a98993          	addi	s3,s3,618 # 1350 <malloc+0x11e>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	25898993          	addi	s3,s3,600 # 1348 <malloc+0x116>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	5a7d                	li	s4,-1
      fc:	00001917          	auipc	s2,0x1
     100:	50490913          	addi	s2,s2,1284 # 1600 <malloc+0x3ce>
     104:	a825                	j	13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	24e50513          	addi	a0,a0,590 # 1358 <malloc+0x126>
     112:	00001097          	auipc	ra,0x1
     116:	d26080e7          	jalr	-730(ra) # e38 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d06080e7          	jalr	-762(ra) # e20 <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	ce4080e7          	jalr	-796(ra) # e18 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	47d9                	li	a5,22
     152:	fca7e8e3          	bltu	a5,a0,122 <go+0xaa>
     156:	050a                	slli	a0,a0,0x2
     158:	954a                	add	a0,a0,s2
     15a:	411c                	lw	a5,0(a0)
     15c:	97ca                	add	a5,a5,s2
     15e:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     160:	20200593          	li	a1,514
     164:	00001517          	auipc	a0,0x1
     168:	20450513          	addi	a0,a0,516 # 1368 <malloc+0x136>
     16c:	00001097          	auipc	ra,0x1
     170:	ccc080e7          	jalr	-820(ra) # e38 <open>
     174:	00001097          	auipc	ra,0x1
     178:	cac080e7          	jalr	-852(ra) # e20 <close>
     17c:	b75d                	j	122 <go+0xaa>
    } else if(what == 3){
      unlink("grindir/../a");
     17e:	00001517          	auipc	a0,0x1
     182:	1da50513          	addi	a0,a0,474 # 1358 <malloc+0x126>
     186:	00001097          	auipc	ra,0x1
     18a:	cc2080e7          	jalr	-830(ra) # e48 <unlink>
     18e:	bf51                	j	122 <go+0xaa>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     190:	00001517          	auipc	a0,0x1
     194:	18850513          	addi	a0,a0,392 # 1318 <malloc+0xe6>
     198:	00001097          	auipc	ra,0x1
     19c:	cd8080e7          	jalr	-808(ra) # e70 <chdir>
     1a0:	e115                	bnez	a0,1c4 <go+0x14c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	1de50513          	addi	a0,a0,478 # 1380 <malloc+0x14e>
     1aa:	00001097          	auipc	ra,0x1
     1ae:	c9e080e7          	jalr	-866(ra) # e48 <unlink>
      chdir("/");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	18e50513          	addi	a0,a0,398 # 1340 <malloc+0x10e>
     1ba:	00001097          	auipc	ra,0x1
     1be:	cb6080e7          	jalr	-842(ra) # e70 <chdir>
     1c2:	b785                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	15c50513          	addi	a0,a0,348 # 1320 <malloc+0xee>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	fae080e7          	jalr	-82(ra) # 117a <printf>
        exit(1);
     1d4:	4505                	li	a0,1
     1d6:	00001097          	auipc	ra,0x1
     1da:	c22080e7          	jalr	-990(ra) # df8 <exit>
    } else if(what == 5){
      close(fd);
     1de:	8552                	mv	a0,s4
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c40080e7          	jalr	-960(ra) # e20 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1e8:	20200593          	li	a1,514
     1ec:	00001517          	auipc	a0,0x1
     1f0:	19c50513          	addi	a0,a0,412 # 1388 <malloc+0x156>
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c44080e7          	jalr	-956(ra) # e38 <open>
     1fc:	8a2a                	mv	s4,a0
     1fe:	b715                	j	122 <go+0xaa>
    } else if(what == 6){
      close(fd);
     200:	8552                	mv	a0,s4
     202:	00001097          	auipc	ra,0x1
     206:	c1e080e7          	jalr	-994(ra) # e20 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	18a50513          	addi	a0,a0,394 # 1398 <malloc+0x166>
     216:	00001097          	auipc	ra,0x1
     21a:	c22080e7          	jalr	-990(ra) # e38 <open>
     21e:	8a2a                	mv	s4,a0
     220:	b709                	j	122 <go+0xaa>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     222:	3e700613          	li	a2,999
     226:	00001597          	auipc	a1,0x1
     22a:	4c258593          	addi	a1,a1,1218 # 16e8 <buf.0>
     22e:	8552                	mv	a0,s4
     230:	00001097          	auipc	ra,0x1
     234:	be8080e7          	jalr	-1048(ra) # e18 <write>
     238:	b5ed                	j	122 <go+0xaa>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23a:	3e700613          	li	a2,999
     23e:	00001597          	auipc	a1,0x1
     242:	4aa58593          	addi	a1,a1,1194 # 16e8 <buf.0>
     246:	8552                	mv	a0,s4
     248:	00001097          	auipc	ra,0x1
     24c:	bc8080e7          	jalr	-1080(ra) # e10 <read>
     250:	bdc9                	j	122 <go+0xaa>
    } else if(what == 9){
      mkdir("grindir/../a");
     252:	00001517          	auipc	a0,0x1
     256:	10650513          	addi	a0,a0,262 # 1358 <malloc+0x126>
     25a:	00001097          	auipc	ra,0x1
     25e:	c0e080e7          	jalr	-1010(ra) # e68 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     262:	20200593          	li	a1,514
     266:	00001517          	auipc	a0,0x1
     26a:	14a50513          	addi	a0,a0,330 # 13b0 <malloc+0x17e>
     26e:	00001097          	auipc	ra,0x1
     272:	bca080e7          	jalr	-1078(ra) # e38 <open>
     276:	00001097          	auipc	ra,0x1
     27a:	baa080e7          	jalr	-1110(ra) # e20 <close>
      unlink("a/a");
     27e:	00001517          	auipc	a0,0x1
     282:	14250513          	addi	a0,a0,322 # 13c0 <malloc+0x18e>
     286:	00001097          	auipc	ra,0x1
     28a:	bc2080e7          	jalr	-1086(ra) # e48 <unlink>
     28e:	bd51                	j	122 <go+0xaa>
    } else if(what == 10){
      mkdir("/../b");
     290:	00001517          	auipc	a0,0x1
     294:	13850513          	addi	a0,a0,312 # 13c8 <malloc+0x196>
     298:	00001097          	auipc	ra,0x1
     29c:	bd0080e7          	jalr	-1072(ra) # e68 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	12c50513          	addi	a0,a0,300 # 13d0 <malloc+0x19e>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	b8c080e7          	jalr	-1140(ra) # e38 <open>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	b6c080e7          	jalr	-1172(ra) # e20 <close>
      unlink("b/b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	12450513          	addi	a0,a0,292 # 13e0 <malloc+0x1ae>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	b84080e7          	jalr	-1148(ra) # e48 <unlink>
     2cc:	bd99                	j	122 <go+0xaa>
    } else if(what == 11){
      unlink("b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	0da50513          	addi	a0,a0,218 # 13a8 <malloc+0x176>
     2d6:	00001097          	auipc	ra,0x1
     2da:	b72080e7          	jalr	-1166(ra) # e48 <unlink>
      link("../grindir/./../a", "../b");
     2de:	00001597          	auipc	a1,0x1
     2e2:	0a258593          	addi	a1,a1,162 # 1380 <malloc+0x14e>
     2e6:	00001517          	auipc	a0,0x1
     2ea:	10250513          	addi	a0,a0,258 # 13e8 <malloc+0x1b6>
     2ee:	00001097          	auipc	ra,0x1
     2f2:	b72080e7          	jalr	-1166(ra) # e60 <link>
     2f6:	b535                	j	122 <go+0xaa>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	10850513          	addi	a0,a0,264 # 1400 <malloc+0x1ce>
     300:	00001097          	auipc	ra,0x1
     304:	b48080e7          	jalr	-1208(ra) # e48 <unlink>
      link(".././b", "/grindir/../a");
     308:	00001597          	auipc	a1,0x1
     30c:	08058593          	addi	a1,a1,128 # 1388 <malloc+0x156>
     310:	00001517          	auipc	a0,0x1
     314:	10050513          	addi	a0,a0,256 # 1410 <malloc+0x1de>
     318:	00001097          	auipc	ra,0x1
     31c:	b48080e7          	jalr	-1208(ra) # e60 <link>
     320:	b509                	j	122 <go+0xaa>
    } else if(what == 13){
      int pid = fork();
     322:	00001097          	auipc	ra,0x1
     326:	ace080e7          	jalr	-1330(ra) # df0 <fork>
      if(pid == 0){
     32a:	c909                	beqz	a0,33c <go+0x2c4>
        exit(0);
      } else if(pid < 0){
     32c:	00054c63          	bltz	a0,344 <go+0x2cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     330:	4501                	li	a0,0
     332:	00001097          	auipc	ra,0x1
     336:	ace080e7          	jalr	-1330(ra) # e00 <wait>
     33a:	b3e5                	j	122 <go+0xaa>
        exit(0);
     33c:	00001097          	auipc	ra,0x1
     340:	abc080e7          	jalr	-1348(ra) # df8 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	0d450513          	addi	a0,a0,212 # 1418 <malloc+0x1e6>
     34c:	00001097          	auipc	ra,0x1
     350:	e2e080e7          	jalr	-466(ra) # 117a <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	00001097          	auipc	ra,0x1
     35a:	aa2080e7          	jalr	-1374(ra) # df8 <exit>
    } else if(what == 14){
      int pid = fork();
     35e:	00001097          	auipc	ra,0x1
     362:	a92080e7          	jalr	-1390(ra) # df0 <fork>
      if(pid == 0){
     366:	c909                	beqz	a0,378 <go+0x300>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     368:	02054563          	bltz	a0,392 <go+0x31a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36c:	4501                	li	a0,0
     36e:	00001097          	auipc	ra,0x1
     372:	a92080e7          	jalr	-1390(ra) # e00 <wait>
     376:	b375                	j	122 <go+0xaa>
        fork();
     378:	00001097          	auipc	ra,0x1
     37c:	a78080e7          	jalr	-1416(ra) # df0 <fork>
        fork();
     380:	00001097          	auipc	ra,0x1
     384:	a70080e7          	jalr	-1424(ra) # df0 <fork>
        exit(0);
     388:	4501                	li	a0,0
     38a:	00001097          	auipc	ra,0x1
     38e:	a6e080e7          	jalr	-1426(ra) # df8 <exit>
        printf("grind: fork failed\n");
     392:	00001517          	auipc	a0,0x1
     396:	08650513          	addi	a0,a0,134 # 1418 <malloc+0x1e6>
     39a:	00001097          	auipc	ra,0x1
     39e:	de0080e7          	jalr	-544(ra) # 117a <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	00001097          	auipc	ra,0x1
     3a8:	a54080e7          	jalr	-1452(ra) # df8 <exit>
    } else if(what == 15){
      sbrk(6011);
     3ac:	6505                	lui	a0,0x1
     3ae:	77b50513          	addi	a0,a0,1915 # 177b <buf.0+0x93>
     3b2:	00001097          	auipc	ra,0x1
     3b6:	ad6080e7          	jalr	-1322(ra) # e88 <sbrk>
     3ba:	b3a5                	j	122 <go+0xaa>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3bc:	4501                	li	a0,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	aca080e7          	jalr	-1334(ra) # e88 <sbrk>
     3c6:	d4aafee3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     3ca:	4501                	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	abc080e7          	jalr	-1348(ra) # e88 <sbrk>
     3d4:	40aa853b          	subw	a0,s5,a0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	ab0080e7          	jalr	-1360(ra) # e88 <sbrk>
     3e0:	b389                	j	122 <go+0xaa>
    } else if(what == 17){
      int pid = fork();
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a0e080e7          	jalr	-1522(ra) # df0 <fork>
     3ea:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ec:	c51d                	beqz	a0,41a <go+0x3a2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ee:	04054963          	bltz	a0,440 <go+0x3c8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f2:	00001517          	auipc	a0,0x1
     3f6:	03e50513          	addi	a0,a0,62 # 1430 <malloc+0x1fe>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	a76080e7          	jalr	-1418(ra) # e70 <chdir>
     402:	ed21                	bnez	a0,45a <go+0x3e2>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     404:	855a                	mv	a0,s6
     406:	00001097          	auipc	ra,0x1
     40a:	a22080e7          	jalr	-1502(ra) # e28 <kill>
      wait(0);
     40e:	4501                	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	9f0080e7          	jalr	-1552(ra) # e00 <wait>
     418:	b329                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     41a:	20200593          	li	a1,514
     41e:	00001517          	auipc	a0,0x1
     422:	fda50513          	addi	a0,a0,-38 # 13f8 <malloc+0x1c6>
     426:	00001097          	auipc	ra,0x1
     42a:	a12080e7          	jalr	-1518(ra) # e38 <open>
     42e:	00001097          	auipc	ra,0x1
     432:	9f2080e7          	jalr	-1550(ra) # e20 <close>
        exit(0);
     436:	4501                	li	a0,0
     438:	00001097          	auipc	ra,0x1
     43c:	9c0080e7          	jalr	-1600(ra) # df8 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	fd850513          	addi	a0,a0,-40 # 1418 <malloc+0x1e6>
     448:	00001097          	auipc	ra,0x1
     44c:	d32080e7          	jalr	-718(ra) # 117a <printf>
        exit(1);
     450:	4505                	li	a0,1
     452:	00001097          	auipc	ra,0x1
     456:	9a6080e7          	jalr	-1626(ra) # df8 <exit>
        printf("grind: chdir failed\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	fe650513          	addi	a0,a0,-26 # 1440 <malloc+0x20e>
     462:	00001097          	auipc	ra,0x1
     466:	d18080e7          	jalr	-744(ra) # 117a <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	00001097          	auipc	ra,0x1
     470:	98c080e7          	jalr	-1652(ra) # df8 <exit>
    } else if(what == 18){
      int pid = fork();
     474:	00001097          	auipc	ra,0x1
     478:	97c080e7          	jalr	-1668(ra) # df0 <fork>
      if(pid == 0){
     47c:	c909                	beqz	a0,48e <go+0x416>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47e:	02054563          	bltz	a0,4a8 <go+0x430>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     482:	4501                	li	a0,0
     484:	00001097          	auipc	ra,0x1
     488:	97c080e7          	jalr	-1668(ra) # e00 <wait>
     48c:	b959                	j	122 <go+0xaa>
        kill(getpid());
     48e:	00001097          	auipc	ra,0x1
     492:	9f2080e7          	jalr	-1550(ra) # e80 <getpid>
     496:	00001097          	auipc	ra,0x1
     49a:	992080e7          	jalr	-1646(ra) # e28 <kill>
        exit(0);
     49e:	4501                	li	a0,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	958080e7          	jalr	-1704(ra) # df8 <exit>
        printf("grind: fork failed\n");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	f7050513          	addi	a0,a0,-144 # 1418 <malloc+0x1e6>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	cca080e7          	jalr	-822(ra) # 117a <printf>
        exit(1);
     4b8:	4505                	li	a0,1
     4ba:	00001097          	auipc	ra,0x1
     4be:	93e080e7          	jalr	-1730(ra) # df8 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c2:	fa840513          	addi	a0,s0,-88
     4c6:	00001097          	auipc	ra,0x1
     4ca:	942080e7          	jalr	-1726(ra) # e08 <pipe>
     4ce:	02054b63          	bltz	a0,504 <go+0x48c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d2:	00001097          	auipc	ra,0x1
     4d6:	91e080e7          	jalr	-1762(ra) # df0 <fork>
      if(pid == 0){
     4da:	c131                	beqz	a0,51e <go+0x4a6>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4dc:	0a054a63          	bltz	a0,590 <go+0x518>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e0:	fa842503          	lw	a0,-88(s0)
     4e4:	00001097          	auipc	ra,0x1
     4e8:	93c080e7          	jalr	-1732(ra) # e20 <close>
      close(fds[1]);
     4ec:	fac42503          	lw	a0,-84(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	930080e7          	jalr	-1744(ra) # e20 <close>
      wait(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	906080e7          	jalr	-1786(ra) # e00 <wait>
     502:	b105                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	f5450513          	addi	a0,a0,-172 # 1458 <malloc+0x226>
     50c:	00001097          	auipc	ra,0x1
     510:	c6e080e7          	jalr	-914(ra) # 117a <printf>
        exit(1);
     514:	4505                	li	a0,1
     516:	00001097          	auipc	ra,0x1
     51a:	8e2080e7          	jalr	-1822(ra) # df8 <exit>
        fork();
     51e:	00001097          	auipc	ra,0x1
     522:	8d2080e7          	jalr	-1838(ra) # df0 <fork>
        fork();
     526:	00001097          	auipc	ra,0x1
     52a:	8ca080e7          	jalr	-1846(ra) # df0 <fork>
        if(write(fds[1], "x", 1) != 1)
     52e:	4605                	li	a2,1
     530:	00001597          	auipc	a1,0x1
     534:	f4058593          	addi	a1,a1,-192 # 1470 <malloc+0x23e>
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00001097          	auipc	ra,0x1
     540:	8dc080e7          	jalr	-1828(ra) # e18 <write>
     544:	4785                	li	a5,1
     546:	02f51363          	bne	a0,a5,56c <go+0x4f4>
        if(read(fds[0], &c, 1) != 1)
     54a:	4605                	li	a2,1
     54c:	fa040593          	addi	a1,s0,-96
     550:	fa842503          	lw	a0,-88(s0)
     554:	00001097          	auipc	ra,0x1
     558:	8bc080e7          	jalr	-1860(ra) # e10 <read>
     55c:	4785                	li	a5,1
     55e:	02f51063          	bne	a0,a5,57e <go+0x506>
        exit(0);
     562:	4501                	li	a0,0
     564:	00001097          	auipc	ra,0x1
     568:	894080e7          	jalr	-1900(ra) # df8 <exit>
          printf("grind: pipe write failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	f0c50513          	addi	a0,a0,-244 # 1478 <malloc+0x246>
     574:	00001097          	auipc	ra,0x1
     578:	c06080e7          	jalr	-1018(ra) # 117a <printf>
     57c:	b7f9                	j	54a <go+0x4d2>
          printf("grind: pipe read failed\n");
     57e:	00001517          	auipc	a0,0x1
     582:	f1a50513          	addi	a0,a0,-230 # 1498 <malloc+0x266>
     586:	00001097          	auipc	ra,0x1
     58a:	bf4080e7          	jalr	-1036(ra) # 117a <printf>
     58e:	bfd1                	j	562 <go+0x4ea>
        printf("grind: fork failed\n");
     590:	00001517          	auipc	a0,0x1
     594:	e8850513          	addi	a0,a0,-376 # 1418 <malloc+0x1e6>
     598:	00001097          	auipc	ra,0x1
     59c:	be2080e7          	jalr	-1054(ra) # 117a <printf>
        exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00001097          	auipc	ra,0x1
     5a6:	856080e7          	jalr	-1962(ra) # df8 <exit>
    } else if(what == 20){
      int pid = fork();
     5aa:	00001097          	auipc	ra,0x1
     5ae:	846080e7          	jalr	-1978(ra) # df0 <fork>
      if(pid == 0){
     5b2:	c909                	beqz	a0,5c4 <go+0x54c>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b4:	06054f63          	bltz	a0,632 <go+0x5ba>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b8:	4501                	li	a0,0
     5ba:	00001097          	auipc	ra,0x1
     5be:	846080e7          	jalr	-1978(ra) # e00 <wait>
     5c2:	b685                	j	122 <go+0xaa>
        unlink("a");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	e3450513          	addi	a0,a0,-460 # 13f8 <malloc+0x1c6>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	87c080e7          	jalr	-1924(ra) # e48 <unlink>
        mkdir("a");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e2450513          	addi	a0,a0,-476 # 13f8 <malloc+0x1c6>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	88c080e7          	jalr	-1908(ra) # e68 <mkdir>
        chdir("a");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	e1450513          	addi	a0,a0,-492 # 13f8 <malloc+0x1c6>
     5ec:	00001097          	auipc	ra,0x1
     5f0:	884080e7          	jalr	-1916(ra) # e70 <chdir>
        unlink("../a");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	d6c50513          	addi	a0,a0,-660 # 1360 <malloc+0x12e>
     5fc:	00001097          	auipc	ra,0x1
     600:	84c080e7          	jalr	-1972(ra) # e48 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     604:	20200593          	li	a1,514
     608:	00001517          	auipc	a0,0x1
     60c:	e6850513          	addi	a0,a0,-408 # 1470 <malloc+0x23e>
     610:	00001097          	auipc	ra,0x1
     614:	828080e7          	jalr	-2008(ra) # e38 <open>
        unlink("x");
     618:	00001517          	auipc	a0,0x1
     61c:	e5850513          	addi	a0,a0,-424 # 1470 <malloc+0x23e>
     620:	00001097          	auipc	ra,0x1
     624:	828080e7          	jalr	-2008(ra) # e48 <unlink>
        exit(0);
     628:	4501                	li	a0,0
     62a:	00000097          	auipc	ra,0x0
     62e:	7ce080e7          	jalr	1998(ra) # df8 <exit>
        printf("grind: fork failed\n");
     632:	00001517          	auipc	a0,0x1
     636:	de650513          	addi	a0,a0,-538 # 1418 <malloc+0x1e6>
     63a:	00001097          	auipc	ra,0x1
     63e:	b40080e7          	jalr	-1216(ra) # 117a <printf>
        exit(1);
     642:	4505                	li	a0,1
     644:	00000097          	auipc	ra,0x0
     648:	7b4080e7          	jalr	1972(ra) # df8 <exit>
    } else if(what == 21){
      unlink("c");
     64c:	00001517          	auipc	a0,0x1
     650:	e6c50513          	addi	a0,a0,-404 # 14b8 <malloc+0x286>
     654:	00000097          	auipc	ra,0x0
     658:	7f4080e7          	jalr	2036(ra) # e48 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65c:	20200593          	li	a1,514
     660:	00001517          	auipc	a0,0x1
     664:	e5850513          	addi	a0,a0,-424 # 14b8 <malloc+0x286>
     668:	00000097          	auipc	ra,0x0
     66c:	7d0080e7          	jalr	2000(ra) # e38 <open>
     670:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     672:	04054f63          	bltz	a0,6d0 <go+0x658>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     676:	4605                	li	a2,1
     678:	00001597          	auipc	a1,0x1
     67c:	df858593          	addi	a1,a1,-520 # 1470 <malloc+0x23e>
     680:	00000097          	auipc	ra,0x0
     684:	798080e7          	jalr	1944(ra) # e18 <write>
     688:	4785                	li	a5,1
     68a:	06f51063          	bne	a0,a5,6ea <go+0x672>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68e:	fa840593          	addi	a1,s0,-88
     692:	855a                	mv	a0,s6
     694:	00000097          	auipc	ra,0x0
     698:	7c4080e7          	jalr	1988(ra) # e58 <fstat>
     69c:	e525                	bnez	a0,704 <go+0x68c>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69e:	fb843583          	ld	a1,-72(s0)
     6a2:	4785                	li	a5,1
     6a4:	06f59d63          	bne	a1,a5,71e <go+0x6a6>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a8:	fac42583          	lw	a1,-84(s0)
     6ac:	0c800793          	li	a5,200
     6b0:	08b7e563          	bltu	a5,a1,73a <go+0x6c2>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b4:	855a                	mv	a0,s6
     6b6:	00000097          	auipc	ra,0x0
     6ba:	76a080e7          	jalr	1898(ra) # e20 <close>
      unlink("c");
     6be:	00001517          	auipc	a0,0x1
     6c2:	dfa50513          	addi	a0,a0,-518 # 14b8 <malloc+0x286>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	782080e7          	jalr	1922(ra) # e48 <unlink>
     6ce:	bc91                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	df050513          	addi	a0,a0,-528 # 14c0 <malloc+0x28e>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	aa2080e7          	jalr	-1374(ra) # 117a <printf>
        exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00000097          	auipc	ra,0x0
     6e6:	716080e7          	jalr	1814(ra) # df8 <exit>
        printf("grind: write c failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	dee50513          	addi	a0,a0,-530 # 14d8 <malloc+0x2a6>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	a88080e7          	jalr	-1400(ra) # 117a <printf>
        exit(1);
     6fa:	4505                	li	a0,1
     6fc:	00000097          	auipc	ra,0x0
     700:	6fc080e7          	jalr	1788(ra) # df8 <exit>
        printf("grind: fstat failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	dec50513          	addi	a0,a0,-532 # 14f0 <malloc+0x2be>
     70c:	00001097          	auipc	ra,0x1
     710:	a6e080e7          	jalr	-1426(ra) # 117a <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00000097          	auipc	ra,0x0
     71a:	6e2080e7          	jalr	1762(ra) # df8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71e:	2581                	sext.w	a1,a1
     720:	00001517          	auipc	a0,0x1
     724:	de850513          	addi	a0,a0,-536 # 1508 <malloc+0x2d6>
     728:	00001097          	auipc	ra,0x1
     72c:	a52080e7          	jalr	-1454(ra) # 117a <printf>
        exit(1);
     730:	4505                	li	a0,1
     732:	00000097          	auipc	ra,0x0
     736:	6c6080e7          	jalr	1734(ra) # df8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73a:	00001517          	auipc	a0,0x1
     73e:	df650513          	addi	a0,a0,-522 # 1530 <malloc+0x2fe>
     742:	00001097          	auipc	ra,0x1
     746:	a38080e7          	jalr	-1480(ra) # 117a <printf>
        exit(1);
     74a:	4505                	li	a0,1
     74c:	00000097          	auipc	ra,0x0
     750:	6ac080e7          	jalr	1708(ra) # df8 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     754:	f9840513          	addi	a0,s0,-104
     758:	00000097          	auipc	ra,0x0
     75c:	6b0080e7          	jalr	1712(ra) # e08 <pipe>
     760:	10054063          	bltz	a0,860 <go+0x7e8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     764:	fa040513          	addi	a0,s0,-96
     768:	00000097          	auipc	ra,0x0
     76c:	6a0080e7          	jalr	1696(ra) # e08 <pipe>
     770:	10054663          	bltz	a0,87c <go+0x804>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     774:	00000097          	auipc	ra,0x0
     778:	67c080e7          	jalr	1660(ra) # df0 <fork>
      if(pid1 == 0){
     77c:	10050e63          	beqz	a0,898 <go+0x820>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1c054663          	bltz	a0,94c <go+0x8d4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00000097          	auipc	ra,0x0
     788:	66c080e7          	jalr	1644(ra) # df0 <fork>
      if(pid2 == 0){
     78c:	1c050e63          	beqz	a0,968 <go+0x8f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	2a054a63          	bltz	a0,a44 <go+0x9cc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f9842503          	lw	a0,-104(s0)
     798:	00000097          	auipc	ra,0x0
     79c:	688080e7          	jalr	1672(ra) # e20 <close>
      close(aa[1]);
     7a0:	f9c42503          	lw	a0,-100(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	67c080e7          	jalr	1660(ra) # e20 <close>
      close(bb[1]);
     7ac:	fa442503          	lw	a0,-92(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	670080e7          	jalr	1648(ra) # e20 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f9040593          	addi	a1,s0,-112
     7c2:	fa042503          	lw	a0,-96(s0)
     7c6:	00000097          	auipc	ra,0x0
     7ca:	64a080e7          	jalr	1610(ra) # e10 <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f9140593          	addi	a1,s0,-111
     7d4:	fa042503          	lw	a0,-96(s0)
     7d8:	00000097          	auipc	ra,0x0
     7dc:	638080e7          	jalr	1592(ra) # e10 <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f9240593          	addi	a1,s0,-110
     7e6:	fa042503          	lw	a0,-96(s0)
     7ea:	00000097          	auipc	ra,0x0
     7ee:	626080e7          	jalr	1574(ra) # e10 <read>
      close(bb[0]);
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	62a080e7          	jalr	1578(ra) # e20 <close>
      int st1, st2;
      wait(&st1);
     7fe:	f9440513          	addi	a0,s0,-108
     802:	00000097          	auipc	ra,0x0
     806:	5fe080e7          	jalr	1534(ra) # e00 <wait>
      wait(&st2);
     80a:	fa840513          	addi	a0,s0,-88
     80e:	00000097          	auipc	ra,0x0
     812:	5f2080e7          	jalr	1522(ra) # e00 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f9442783          	lw	a5,-108(s0)
     81a:	fa842703          	lw	a4,-88(s0)
     81e:	8fd9                	or	a5,a5,a4
     820:	ef89                	bnez	a5,83a <go+0x7c2>
     822:	00001597          	auipc	a1,0x1
     826:	dae58593          	addi	a1,a1,-594 # 15d0 <malloc+0x39e>
     82a:	f9040513          	addi	a0,s0,-112
     82e:	00000097          	auipc	ra,0x0
     832:	37a080e7          	jalr	890(ra) # ba8 <strcmp>
     836:	8e0506e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     83a:	f9040693          	addi	a3,s0,-112
     83e:	fa842603          	lw	a2,-88(s0)
     842:	f9442583          	lw	a1,-108(s0)
     846:	00001517          	auipc	a0,0x1
     84a:	d9250513          	addi	a0,a0,-622 # 15d8 <malloc+0x3a6>
     84e:	00001097          	auipc	ra,0x1
     852:	92c080e7          	jalr	-1748(ra) # 117a <printf>
        exit(1);
     856:	4505                	li	a0,1
     858:	00000097          	auipc	ra,0x0
     85c:	5a0080e7          	jalr	1440(ra) # df8 <exit>
        fprintf(2, "grind: pipe failed\n");
     860:	00001597          	auipc	a1,0x1
     864:	bf858593          	addi	a1,a1,-1032 # 1458 <malloc+0x226>
     868:	4509                	li	a0,2
     86a:	00001097          	auipc	ra,0x1
     86e:	8e2080e7          	jalr	-1822(ra) # 114c <fprintf>
        exit(1);
     872:	4505                	li	a0,1
     874:	00000097          	auipc	ra,0x0
     878:	584080e7          	jalr	1412(ra) # df8 <exit>
        fprintf(2, "grind: pipe failed\n");
     87c:	00001597          	auipc	a1,0x1
     880:	bdc58593          	addi	a1,a1,-1060 # 1458 <malloc+0x226>
     884:	4509                	li	a0,2
     886:	00001097          	auipc	ra,0x1
     88a:	8c6080e7          	jalr	-1850(ra) # 114c <fprintf>
        exit(1);
     88e:	4505                	li	a0,1
     890:	00000097          	auipc	ra,0x0
     894:	568080e7          	jalr	1384(ra) # df8 <exit>
        close(bb[0]);
     898:	fa042503          	lw	a0,-96(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	584080e7          	jalr	1412(ra) # e20 <close>
        close(bb[1]);
     8a4:	fa442503          	lw	a0,-92(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	578080e7          	jalr	1400(ra) # e20 <close>
        close(aa[0]);
     8b0:	f9842503          	lw	a0,-104(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	56c080e7          	jalr	1388(ra) # e20 <close>
        close(1);
     8bc:	4505                	li	a0,1
     8be:	00000097          	auipc	ra,0x0
     8c2:	562080e7          	jalr	1378(ra) # e20 <close>
        if(dup(aa[1]) != 1){
     8c6:	f9c42503          	lw	a0,-100(s0)
     8ca:	00000097          	auipc	ra,0x0
     8ce:	5ae080e7          	jalr	1454(ra) # e78 <dup>
     8d2:	4785                	li	a5,1
     8d4:	02f50063          	beq	a0,a5,8f4 <go+0x87c>
          fprintf(2, "grind: dup failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	c8058593          	addi	a1,a1,-896 # 1558 <malloc+0x326>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	86a080e7          	jalr	-1942(ra) # 114c <fprintf>
          exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	50c080e7          	jalr	1292(ra) # df8 <exit>
        close(aa[1]);
     8f4:	f9c42503          	lw	a0,-100(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	528080e7          	jalr	1320(ra) # e20 <close>
        char *args[3] = { "echo", "hi", 0 };
     900:	00001797          	auipc	a5,0x1
     904:	c7078793          	addi	a5,a5,-912 # 1570 <malloc+0x33e>
     908:	faf43423          	sd	a5,-88(s0)
     90c:	00001797          	auipc	a5,0x1
     910:	c6c78793          	addi	a5,a5,-916 # 1578 <malloc+0x346>
     914:	faf43823          	sd	a5,-80(s0)
     918:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     91c:	fa840593          	addi	a1,s0,-88
     920:	00001517          	auipc	a0,0x1
     924:	c6050513          	addi	a0,a0,-928 # 1580 <malloc+0x34e>
     928:	00000097          	auipc	ra,0x0
     92c:	508080e7          	jalr	1288(ra) # e30 <exec>
        fprintf(2, "grind: echo: not found\n");
     930:	00001597          	auipc	a1,0x1
     934:	c6058593          	addi	a1,a1,-928 # 1590 <malloc+0x35e>
     938:	4509                	li	a0,2
     93a:	00001097          	auipc	ra,0x1
     93e:	812080e7          	jalr	-2030(ra) # 114c <fprintf>
        exit(2);
     942:	4509                	li	a0,2
     944:	00000097          	auipc	ra,0x0
     948:	4b4080e7          	jalr	1204(ra) # df8 <exit>
        fprintf(2, "grind: fork failed\n");
     94c:	00001597          	auipc	a1,0x1
     950:	acc58593          	addi	a1,a1,-1332 # 1418 <malloc+0x1e6>
     954:	4509                	li	a0,2
     956:	00000097          	auipc	ra,0x0
     95a:	7f6080e7          	jalr	2038(ra) # 114c <fprintf>
        exit(3);
     95e:	450d                	li	a0,3
     960:	00000097          	auipc	ra,0x0
     964:	498080e7          	jalr	1176(ra) # df8 <exit>
        close(aa[1]);
     968:	f9c42503          	lw	a0,-100(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	4b4080e7          	jalr	1204(ra) # e20 <close>
        close(bb[0]);
     974:	fa042503          	lw	a0,-96(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	4a8080e7          	jalr	1192(ra) # e20 <close>
        close(0);
     980:	4501                	li	a0,0
     982:	00000097          	auipc	ra,0x0
     986:	49e080e7          	jalr	1182(ra) # e20 <close>
        if(dup(aa[0]) != 0){
     98a:	f9842503          	lw	a0,-104(s0)
     98e:	00000097          	auipc	ra,0x0
     992:	4ea080e7          	jalr	1258(ra) # e78 <dup>
     996:	cd19                	beqz	a0,9b4 <go+0x93c>
          fprintf(2, "grind: dup failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	bc058593          	addi	a1,a1,-1088 # 1558 <malloc+0x326>
     9a0:	4509                	li	a0,2
     9a2:	00000097          	auipc	ra,0x0
     9a6:	7aa080e7          	jalr	1962(ra) # 114c <fprintf>
          exit(4);
     9aa:	4511                	li	a0,4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	44c080e7          	jalr	1100(ra) # df8 <exit>
        close(aa[0]);
     9b4:	f9842503          	lw	a0,-104(s0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	468080e7          	jalr	1128(ra) # e20 <close>
        close(1);
     9c0:	4505                	li	a0,1
     9c2:	00000097          	auipc	ra,0x0
     9c6:	45e080e7          	jalr	1118(ra) # e20 <close>
        if(dup(bb[1]) != 1){
     9ca:	fa442503          	lw	a0,-92(s0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	4aa080e7          	jalr	1194(ra) # e78 <dup>
     9d6:	4785                	li	a5,1
     9d8:	02f50063          	beq	a0,a5,9f8 <go+0x980>
          fprintf(2, "grind: dup failed\n");
     9dc:	00001597          	auipc	a1,0x1
     9e0:	b7c58593          	addi	a1,a1,-1156 # 1558 <malloc+0x326>
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	766080e7          	jalr	1894(ra) # 114c <fprintf>
          exit(5);
     9ee:	4515                	li	a0,5
     9f0:	00000097          	auipc	ra,0x0
     9f4:	408080e7          	jalr	1032(ra) # df8 <exit>
        close(bb[1]);
     9f8:	fa442503          	lw	a0,-92(s0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	424080e7          	jalr	1060(ra) # e20 <close>
        char *args[2] = { "cat", 0 };
     a04:	00001797          	auipc	a5,0x1
     a08:	ba478793          	addi	a5,a5,-1116 # 15a8 <malloc+0x376>
     a0c:	faf43423          	sd	a5,-88(s0)
     a10:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a14:	fa840593          	addi	a1,s0,-88
     a18:	00001517          	auipc	a0,0x1
     a1c:	b9850513          	addi	a0,a0,-1128 # 15b0 <malloc+0x37e>
     a20:	00000097          	auipc	ra,0x0
     a24:	410080e7          	jalr	1040(ra) # e30 <exec>
        fprintf(2, "grind: cat: not found\n");
     a28:	00001597          	auipc	a1,0x1
     a2c:	b9058593          	addi	a1,a1,-1136 # 15b8 <malloc+0x386>
     a30:	4509                	li	a0,2
     a32:	00000097          	auipc	ra,0x0
     a36:	71a080e7          	jalr	1818(ra) # 114c <fprintf>
        exit(6);
     a3a:	4519                	li	a0,6
     a3c:	00000097          	auipc	ra,0x0
     a40:	3bc080e7          	jalr	956(ra) # df8 <exit>
        fprintf(2, "grind: fork failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	9d458593          	addi	a1,a1,-1580 # 1418 <malloc+0x1e6>
     a4c:	4509                	li	a0,2
     a4e:	00000097          	auipc	ra,0x0
     a52:	6fe080e7          	jalr	1790(ra) # 114c <fprintf>
        exit(7);
     a56:	451d                	li	a0,7
     a58:	00000097          	auipc	ra,0x0
     a5c:	3a0080e7          	jalr	928(ra) # df8 <exit>

0000000000000a60 <iter>:
  }
}

void
iter()
{
     a60:	7179                	addi	sp,sp,-48
     a62:	f406                	sd	ra,40(sp)
     a64:	f022                	sd	s0,32(sp)
     a66:	ec26                	sd	s1,24(sp)
     a68:	e84a                	sd	s2,16(sp)
     a6a:	1800                	addi	s0,sp,48
  unlink("a");
     a6c:	00001517          	auipc	a0,0x1
     a70:	98c50513          	addi	a0,a0,-1652 # 13f8 <malloc+0x1c6>
     a74:	00000097          	auipc	ra,0x0
     a78:	3d4080e7          	jalr	980(ra) # e48 <unlink>
  unlink("b");
     a7c:	00001517          	auipc	a0,0x1
     a80:	92c50513          	addi	a0,a0,-1748 # 13a8 <malloc+0x176>
     a84:	00000097          	auipc	ra,0x0
     a88:	3c4080e7          	jalr	964(ra) # e48 <unlink>
  
  int pid1 = fork();
     a8c:	00000097          	auipc	ra,0x0
     a90:	364080e7          	jalr	868(ra) # df0 <fork>
  if(pid1 < 0){
     a94:	00054e63          	bltz	a0,ab0 <iter+0x50>
     a98:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9a:	e905                	bnez	a0,aca <iter+0x6a>
    rand_next = 31;
     a9c:	47fd                	li	a5,31
     a9e:	00001717          	auipc	a4,0x1
     aa2:	c2f73d23          	sd	a5,-966(a4) # 16d8 <rand_next>
    go(0);
     aa6:	4501                	li	a0,0
     aa8:	fffff097          	auipc	ra,0xfffff
     aac:	5d0080e7          	jalr	1488(ra) # 78 <go>
    printf("grind: fork failed\n");
     ab0:	00001517          	auipc	a0,0x1
     ab4:	96850513          	addi	a0,a0,-1688 # 1418 <malloc+0x1e6>
     ab8:	00000097          	auipc	ra,0x0
     abc:	6c2080e7          	jalr	1730(ra) # 117a <printf>
    exit(1);
     ac0:	4505                	li	a0,1
     ac2:	00000097          	auipc	ra,0x0
     ac6:	336080e7          	jalr	822(ra) # df8 <exit>
    exit(0);
  }

  int pid2 = fork();
     aca:	00000097          	auipc	ra,0x0
     ace:	326080e7          	jalr	806(ra) # df0 <fork>
     ad2:	892a                	mv	s2,a0
  if(pid2 < 0){
     ad4:	00054f63          	bltz	a0,af2 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ad8:	e915                	bnez	a0,b0c <iter+0xac>
    rand_next = 7177;
     ada:	6789                	lui	a5,0x2
     adc:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x129>
     ae0:	00001717          	auipc	a4,0x1
     ae4:	bef73c23          	sd	a5,-1032(a4) # 16d8 <rand_next>
    go(1);
     ae8:	4505                	li	a0,1
     aea:	fffff097          	auipc	ra,0xfffff
     aee:	58e080e7          	jalr	1422(ra) # 78 <go>
    printf("grind: fork failed\n");
     af2:	00001517          	auipc	a0,0x1
     af6:	92650513          	addi	a0,a0,-1754 # 1418 <malloc+0x1e6>
     afa:	00000097          	auipc	ra,0x0
     afe:	680080e7          	jalr	1664(ra) # 117a <printf>
    exit(1);
     b02:	4505                	li	a0,1
     b04:	00000097          	auipc	ra,0x0
     b08:	2f4080e7          	jalr	756(ra) # df8 <exit>
    exit(0);
  }

  int st1 = -1;
     b0c:	57fd                	li	a5,-1
     b0e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b12:	fdc40513          	addi	a0,s0,-36
     b16:	00000097          	auipc	ra,0x0
     b1a:	2ea080e7          	jalr	746(ra) # e00 <wait>
  if(st1 != 0){
     b1e:	fdc42783          	lw	a5,-36(s0)
     b22:	ef99                	bnez	a5,b40 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b24:	57fd                	li	a5,-1
     b26:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b2a:	fd840513          	addi	a0,s0,-40
     b2e:	00000097          	auipc	ra,0x0
     b32:	2d2080e7          	jalr	722(ra) # e00 <wait>

  exit(0);
     b36:	4501                	li	a0,0
     b38:	00000097          	auipc	ra,0x0
     b3c:	2c0080e7          	jalr	704(ra) # df8 <exit>
    kill(pid1);
     b40:	8526                	mv	a0,s1
     b42:	00000097          	auipc	ra,0x0
     b46:	2e6080e7          	jalr	742(ra) # e28 <kill>
    kill(pid2);
     b4a:	854a                	mv	a0,s2
     b4c:	00000097          	auipc	ra,0x0
     b50:	2dc080e7          	jalr	732(ra) # e28 <kill>
     b54:	bfc1                	j	b24 <iter+0xc4>

0000000000000b56 <main>:
}

int
main()
{
     b56:	1141                	addi	sp,sp,-16
     b58:	e406                	sd	ra,8(sp)
     b5a:	e022                	sd	s0,0(sp)
     b5c:	0800                	addi	s0,sp,16
     b5e:	a811                	j	b72 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     b60:	00000097          	auipc	ra,0x0
     b64:	f00080e7          	jalr	-256(ra) # a60 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     b68:	4551                	li	a0,20
     b6a:	00000097          	auipc	ra,0x0
     b6e:	326080e7          	jalr	806(ra) # e90 <sleep>
    int pid = fork();
     b72:	00000097          	auipc	ra,0x0
     b76:	27e080e7          	jalr	638(ra) # df0 <fork>
    if(pid == 0){
     b7a:	d17d                	beqz	a0,b60 <main+0xa>
    if(pid > 0){
     b7c:	fea056e3          	blez	a0,b68 <main+0x12>
      wait(0);
     b80:	4501                	li	a0,0
     b82:	00000097          	auipc	ra,0x0
     b86:	27e080e7          	jalr	638(ra) # e00 <wait>
     b8a:	bff9                	j	b68 <main+0x12>

0000000000000b8c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b8c:	1141                	addi	sp,sp,-16
     b8e:	e422                	sd	s0,8(sp)
     b90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b92:	87aa                	mv	a5,a0
     b94:	0585                	addi	a1,a1,1
     b96:	0785                	addi	a5,a5,1
     b98:	fff5c703          	lbu	a4,-1(a1)
     b9c:	fee78fa3          	sb	a4,-1(a5)
     ba0:	fb75                	bnez	a4,b94 <strcpy+0x8>
    ;
  return os;
}
     ba2:	6422                	ld	s0,8(sp)
     ba4:	0141                	addi	sp,sp,16
     ba6:	8082                	ret

0000000000000ba8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e422                	sd	s0,8(sp)
     bac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bae:	00054783          	lbu	a5,0(a0)
     bb2:	cb91                	beqz	a5,bc6 <strcmp+0x1e>
     bb4:	0005c703          	lbu	a4,0(a1)
     bb8:	00f71763          	bne	a4,a5,bc6 <strcmp+0x1e>
    p++, q++;
     bbc:	0505                	addi	a0,a0,1
     bbe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	fbe5                	bnez	a5,bb4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bc6:	0005c503          	lbu	a0,0(a1)
}
     bca:	40a7853b          	subw	a0,a5,a0
     bce:	6422                	ld	s0,8(sp)
     bd0:	0141                	addi	sp,sp,16
     bd2:	8082                	ret

0000000000000bd4 <strlen>:

uint
strlen(const char *s)
{
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bda:	00054783          	lbu	a5,0(a0)
     bde:	cf91                	beqz	a5,bfa <strlen+0x26>
     be0:	0505                	addi	a0,a0,1
     be2:	87aa                	mv	a5,a0
     be4:	4685                	li	a3,1
     be6:	9e89                	subw	a3,a3,a0
     be8:	00f6853b          	addw	a0,a3,a5
     bec:	0785                	addi	a5,a5,1
     bee:	fff7c703          	lbu	a4,-1(a5)
     bf2:	fb7d                	bnez	a4,be8 <strlen+0x14>
    ;
  return n;
}
     bf4:	6422                	ld	s0,8(sp)
     bf6:	0141                	addi	sp,sp,16
     bf8:	8082                	ret
  for(n = 0; s[n]; n++)
     bfa:	4501                	li	a0,0
     bfc:	bfe5                	j	bf4 <strlen+0x20>

0000000000000bfe <memset>:

void*
memset(void *dst, int c, uint n)
{
     bfe:	1141                	addi	sp,sp,-16
     c00:	e422                	sd	s0,8(sp)
     c02:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c04:	ca19                	beqz	a2,c1a <memset+0x1c>
     c06:	87aa                	mv	a5,a0
     c08:	1602                	slli	a2,a2,0x20
     c0a:	9201                	srli	a2,a2,0x20
     c0c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c10:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c14:	0785                	addi	a5,a5,1
     c16:	fee79de3          	bne	a5,a4,c10 <memset+0x12>
  }
  return dst;
}
     c1a:	6422                	ld	s0,8(sp)
     c1c:	0141                	addi	sp,sp,16
     c1e:	8082                	ret

0000000000000c20 <strchr>:

char*
strchr(const char *s, char c)
{
     c20:	1141                	addi	sp,sp,-16
     c22:	e422                	sd	s0,8(sp)
     c24:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c26:	00054783          	lbu	a5,0(a0)
     c2a:	cb99                	beqz	a5,c40 <strchr+0x20>
    if(*s == c)
     c2c:	00f58763          	beq	a1,a5,c3a <strchr+0x1a>
  for(; *s; s++)
     c30:	0505                	addi	a0,a0,1
     c32:	00054783          	lbu	a5,0(a0)
     c36:	fbfd                	bnez	a5,c2c <strchr+0xc>
      return (char*)s;
  return 0;
     c38:	4501                	li	a0,0
}
     c3a:	6422                	ld	s0,8(sp)
     c3c:	0141                	addi	sp,sp,16
     c3e:	8082                	ret
  return 0;
     c40:	4501                	li	a0,0
     c42:	bfe5                	j	c3a <strchr+0x1a>

0000000000000c44 <gets>:

char*
gets(char *buf, int max)
{
     c44:	711d                	addi	sp,sp,-96
     c46:	ec86                	sd	ra,88(sp)
     c48:	e8a2                	sd	s0,80(sp)
     c4a:	e4a6                	sd	s1,72(sp)
     c4c:	e0ca                	sd	s2,64(sp)
     c4e:	fc4e                	sd	s3,56(sp)
     c50:	f852                	sd	s4,48(sp)
     c52:	f456                	sd	s5,40(sp)
     c54:	f05a                	sd	s6,32(sp)
     c56:	ec5e                	sd	s7,24(sp)
     c58:	1080                	addi	s0,sp,96
     c5a:	8baa                	mv	s7,a0
     c5c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c5e:	892a                	mv	s2,a0
     c60:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c62:	4aa9                	li	s5,10
     c64:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c66:	89a6                	mv	s3,s1
     c68:	2485                	addiw	s1,s1,1
     c6a:	0344d863          	bge	s1,s4,c9a <gets+0x56>
    cc = read(0, &c, 1);
     c6e:	4605                	li	a2,1
     c70:	faf40593          	addi	a1,s0,-81
     c74:	4501                	li	a0,0
     c76:	00000097          	auipc	ra,0x0
     c7a:	19a080e7          	jalr	410(ra) # e10 <read>
    if(cc < 1)
     c7e:	00a05e63          	blez	a0,c9a <gets+0x56>
    buf[i++] = c;
     c82:	faf44783          	lbu	a5,-81(s0)
     c86:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c8a:	01578763          	beq	a5,s5,c98 <gets+0x54>
     c8e:	0905                	addi	s2,s2,1
     c90:	fd679be3          	bne	a5,s6,c66 <gets+0x22>
  for(i=0; i+1 < max; ){
     c94:	89a6                	mv	s3,s1
     c96:	a011                	j	c9a <gets+0x56>
     c98:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c9a:	99de                	add	s3,s3,s7
     c9c:	00098023          	sb	zero,0(s3)
  return buf;
}
     ca0:	855e                	mv	a0,s7
     ca2:	60e6                	ld	ra,88(sp)
     ca4:	6446                	ld	s0,80(sp)
     ca6:	64a6                	ld	s1,72(sp)
     ca8:	6906                	ld	s2,64(sp)
     caa:	79e2                	ld	s3,56(sp)
     cac:	7a42                	ld	s4,48(sp)
     cae:	7aa2                	ld	s5,40(sp)
     cb0:	7b02                	ld	s6,32(sp)
     cb2:	6be2                	ld	s7,24(sp)
     cb4:	6125                	addi	sp,sp,96
     cb6:	8082                	ret

0000000000000cb8 <stat>:

int
stat(const char *n, struct stat *st)
{
     cb8:	1101                	addi	sp,sp,-32
     cba:	ec06                	sd	ra,24(sp)
     cbc:	e822                	sd	s0,16(sp)
     cbe:	e426                	sd	s1,8(sp)
     cc0:	e04a                	sd	s2,0(sp)
     cc2:	1000                	addi	s0,sp,32
     cc4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cc6:	4581                	li	a1,0
     cc8:	00000097          	auipc	ra,0x0
     ccc:	170080e7          	jalr	368(ra) # e38 <open>
  if(fd < 0)
     cd0:	02054563          	bltz	a0,cfa <stat+0x42>
     cd4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cd6:	85ca                	mv	a1,s2
     cd8:	00000097          	auipc	ra,0x0
     cdc:	180080e7          	jalr	384(ra) # e58 <fstat>
     ce0:	892a                	mv	s2,a0
  close(fd);
     ce2:	8526                	mv	a0,s1
     ce4:	00000097          	auipc	ra,0x0
     ce8:	13c080e7          	jalr	316(ra) # e20 <close>
  return r;
}
     cec:	854a                	mv	a0,s2
     cee:	60e2                	ld	ra,24(sp)
     cf0:	6442                	ld	s0,16(sp)
     cf2:	64a2                	ld	s1,8(sp)
     cf4:	6902                	ld	s2,0(sp)
     cf6:	6105                	addi	sp,sp,32
     cf8:	8082                	ret
    return -1;
     cfa:	597d                	li	s2,-1
     cfc:	bfc5                	j	cec <stat+0x34>

0000000000000cfe <atoi>:

int
atoi(const char *s)
{
     cfe:	1141                	addi	sp,sp,-16
     d00:	e422                	sd	s0,8(sp)
     d02:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d04:	00054683          	lbu	a3,0(a0)
     d08:	fd06879b          	addiw	a5,a3,-48
     d0c:	0ff7f793          	zext.b	a5,a5
     d10:	4625                	li	a2,9
     d12:	02f66863          	bltu	a2,a5,d42 <atoi+0x44>
     d16:	872a                	mv	a4,a0
  n = 0;
     d18:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d1a:	0705                	addi	a4,a4,1
     d1c:	0025179b          	slliw	a5,a0,0x2
     d20:	9fa9                	addw	a5,a5,a0
     d22:	0017979b          	slliw	a5,a5,0x1
     d26:	9fb5                	addw	a5,a5,a3
     d28:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d2c:	00074683          	lbu	a3,0(a4)
     d30:	fd06879b          	addiw	a5,a3,-48
     d34:	0ff7f793          	zext.b	a5,a5
     d38:	fef671e3          	bgeu	a2,a5,d1a <atoi+0x1c>
  return n;
}
     d3c:	6422                	ld	s0,8(sp)
     d3e:	0141                	addi	sp,sp,16
     d40:	8082                	ret
  n = 0;
     d42:	4501                	li	a0,0
     d44:	bfe5                	j	d3c <atoi+0x3e>

0000000000000d46 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d46:	1141                	addi	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d4c:	02b57463          	bgeu	a0,a1,d74 <memmove+0x2e>
    while(n-- > 0)
     d50:	00c05f63          	blez	a2,d6e <memmove+0x28>
     d54:	1602                	slli	a2,a2,0x20
     d56:	9201                	srli	a2,a2,0x20
     d58:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d5c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d5e:	0585                	addi	a1,a1,1
     d60:	0705                	addi	a4,a4,1
     d62:	fff5c683          	lbu	a3,-1(a1)
     d66:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d6a:	fee79ae3          	bne	a5,a4,d5e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d6e:	6422                	ld	s0,8(sp)
     d70:	0141                	addi	sp,sp,16
     d72:	8082                	ret
    dst += n;
     d74:	00c50733          	add	a4,a0,a2
    src += n;
     d78:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d7a:	fec05ae3          	blez	a2,d6e <memmove+0x28>
     d7e:	fff6079b          	addiw	a5,a2,-1
     d82:	1782                	slli	a5,a5,0x20
     d84:	9381                	srli	a5,a5,0x20
     d86:	fff7c793          	not	a5,a5
     d8a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d8c:	15fd                	addi	a1,a1,-1
     d8e:	177d                	addi	a4,a4,-1
     d90:	0005c683          	lbu	a3,0(a1)
     d94:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d98:	fee79ae3          	bne	a5,a4,d8c <memmove+0x46>
     d9c:	bfc9                	j	d6e <memmove+0x28>

0000000000000d9e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d9e:	1141                	addi	sp,sp,-16
     da0:	e422                	sd	s0,8(sp)
     da2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     da4:	ca05                	beqz	a2,dd4 <memcmp+0x36>
     da6:	fff6069b          	addiw	a3,a2,-1
     daa:	1682                	slli	a3,a3,0x20
     dac:	9281                	srli	a3,a3,0x20
     dae:	0685                	addi	a3,a3,1
     db0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     db2:	00054783          	lbu	a5,0(a0)
     db6:	0005c703          	lbu	a4,0(a1)
     dba:	00e79863          	bne	a5,a4,dca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dbe:	0505                	addi	a0,a0,1
    p2++;
     dc0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dc2:	fed518e3          	bne	a0,a3,db2 <memcmp+0x14>
  }
  return 0;
     dc6:	4501                	li	a0,0
     dc8:	a019                	j	dce <memcmp+0x30>
      return *p1 - *p2;
     dca:	40e7853b          	subw	a0,a5,a4
}
     dce:	6422                	ld	s0,8(sp)
     dd0:	0141                	addi	sp,sp,16
     dd2:	8082                	ret
  return 0;
     dd4:	4501                	li	a0,0
     dd6:	bfe5                	j	dce <memcmp+0x30>

0000000000000dd8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dd8:	1141                	addi	sp,sp,-16
     dda:	e406                	sd	ra,8(sp)
     ddc:	e022                	sd	s0,0(sp)
     dde:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     de0:	00000097          	auipc	ra,0x0
     de4:	f66080e7          	jalr	-154(ra) # d46 <memmove>
}
     de8:	60a2                	ld	ra,8(sp)
     dea:	6402                	ld	s0,0(sp)
     dec:	0141                	addi	sp,sp,16
     dee:	8082                	ret

0000000000000df0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     df0:	4885                	li	a7,1
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     df8:	4889                	li	a7,2
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e00:	488d                	li	a7,3
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e08:	4891                	li	a7,4
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <read>:
.global read
read:
 li a7, SYS_read
     e10:	4895                	li	a7,5
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <write>:
.global write
write:
 li a7, SYS_write
     e18:	48c1                	li	a7,16
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <close>:
.global close
close:
 li a7, SYS_close
     e20:	48d5                	li	a7,21
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e28:	4899                	li	a7,6
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e30:	489d                	li	a7,7
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <open>:
.global open
open:
 li a7, SYS_open
     e38:	48bd                	li	a7,15
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e40:	48c5                	li	a7,17
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e48:	48c9                	li	a7,18
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <trace>:
.global trace
trace:
 li a7, SYS_trace
     e50:	48d9                	li	a7,22
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e58:	48a1                	li	a7,8
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <link>:
.global link
link:
 li a7, SYS_link
     e60:	48cd                	li	a7,19
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e68:	48d1                	li	a7,20
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e70:	48a5                	li	a7,9
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e78:	48a9                	li	a7,10
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e80:	48ad                	li	a7,11
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e88:	48b1                	li	a7,12
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e90:	48b5                	li	a7,13
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e98:	48b9                	li	a7,14
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ea0:	1101                	addi	sp,sp,-32
     ea2:	ec06                	sd	ra,24(sp)
     ea4:	e822                	sd	s0,16(sp)
     ea6:	1000                	addi	s0,sp,32
     ea8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     eac:	4605                	li	a2,1
     eae:	fef40593          	addi	a1,s0,-17
     eb2:	00000097          	auipc	ra,0x0
     eb6:	f66080e7          	jalr	-154(ra) # e18 <write>
}
     eba:	60e2                	ld	ra,24(sp)
     ebc:	6442                	ld	s0,16(sp)
     ebe:	6105                	addi	sp,sp,32
     ec0:	8082                	ret

0000000000000ec2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ec2:	7139                	addi	sp,sp,-64
     ec4:	fc06                	sd	ra,56(sp)
     ec6:	f822                	sd	s0,48(sp)
     ec8:	f426                	sd	s1,40(sp)
     eca:	f04a                	sd	s2,32(sp)
     ecc:	ec4e                	sd	s3,24(sp)
     ece:	0080                	addi	s0,sp,64
     ed0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ed2:	c299                	beqz	a3,ed8 <printint+0x16>
     ed4:	0805c963          	bltz	a1,f66 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ed8:	2581                	sext.w	a1,a1
  neg = 0;
     eda:	4881                	li	a7,0
     edc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ee0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ee2:	2601                	sext.w	a2,a2
     ee4:	00000517          	auipc	a0,0x0
     ee8:	7dc50513          	addi	a0,a0,2012 # 16c0 <digits>
     eec:	883a                	mv	a6,a4
     eee:	2705                	addiw	a4,a4,1
     ef0:	02c5f7bb          	remuw	a5,a1,a2
     ef4:	1782                	slli	a5,a5,0x20
     ef6:	9381                	srli	a5,a5,0x20
     ef8:	97aa                	add	a5,a5,a0
     efa:	0007c783          	lbu	a5,0(a5)
     efe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f02:	0005879b          	sext.w	a5,a1
     f06:	02c5d5bb          	divuw	a1,a1,a2
     f0a:	0685                	addi	a3,a3,1
     f0c:	fec7f0e3          	bgeu	a5,a2,eec <printint+0x2a>
  if(neg)
     f10:	00088c63          	beqz	a7,f28 <printint+0x66>
    buf[i++] = '-';
     f14:	fd070793          	addi	a5,a4,-48
     f18:	00878733          	add	a4,a5,s0
     f1c:	02d00793          	li	a5,45
     f20:	fef70823          	sb	a5,-16(a4)
     f24:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f28:	02e05863          	blez	a4,f58 <printint+0x96>
     f2c:	fc040793          	addi	a5,s0,-64
     f30:	00e78933          	add	s2,a5,a4
     f34:	fff78993          	addi	s3,a5,-1
     f38:	99ba                	add	s3,s3,a4
     f3a:	377d                	addiw	a4,a4,-1
     f3c:	1702                	slli	a4,a4,0x20
     f3e:	9301                	srli	a4,a4,0x20
     f40:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f44:	fff94583          	lbu	a1,-1(s2)
     f48:	8526                	mv	a0,s1
     f4a:	00000097          	auipc	ra,0x0
     f4e:	f56080e7          	jalr	-170(ra) # ea0 <putc>
  while(--i >= 0)
     f52:	197d                	addi	s2,s2,-1
     f54:	ff3918e3          	bne	s2,s3,f44 <printint+0x82>
}
     f58:	70e2                	ld	ra,56(sp)
     f5a:	7442                	ld	s0,48(sp)
     f5c:	74a2                	ld	s1,40(sp)
     f5e:	7902                	ld	s2,32(sp)
     f60:	69e2                	ld	s3,24(sp)
     f62:	6121                	addi	sp,sp,64
     f64:	8082                	ret
    x = -xx;
     f66:	40b005bb          	negw	a1,a1
    neg = 1;
     f6a:	4885                	li	a7,1
    x = -xx;
     f6c:	bf85                	j	edc <printint+0x1a>

0000000000000f6e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f6e:	7119                	addi	sp,sp,-128
     f70:	fc86                	sd	ra,120(sp)
     f72:	f8a2                	sd	s0,112(sp)
     f74:	f4a6                	sd	s1,104(sp)
     f76:	f0ca                	sd	s2,96(sp)
     f78:	ecce                	sd	s3,88(sp)
     f7a:	e8d2                	sd	s4,80(sp)
     f7c:	e4d6                	sd	s5,72(sp)
     f7e:	e0da                	sd	s6,64(sp)
     f80:	fc5e                	sd	s7,56(sp)
     f82:	f862                	sd	s8,48(sp)
     f84:	f466                	sd	s9,40(sp)
     f86:	f06a                	sd	s10,32(sp)
     f88:	ec6e                	sd	s11,24(sp)
     f8a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f8c:	0005c903          	lbu	s2,0(a1)
     f90:	18090f63          	beqz	s2,112e <vprintf+0x1c0>
     f94:	8aaa                	mv	s5,a0
     f96:	8b32                	mv	s6,a2
     f98:	00158493          	addi	s1,a1,1
  state = 0;
     f9c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f9e:	02500a13          	li	s4,37
     fa2:	4c55                	li	s8,21
     fa4:	00000c97          	auipc	s9,0x0
     fa8:	6c4c8c93          	addi	s9,s9,1732 # 1668 <malloc+0x436>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     fac:	02800d93          	li	s11,40
  putc(fd, 'x');
     fb0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fb2:	00000b97          	auipc	s7,0x0
     fb6:	70eb8b93          	addi	s7,s7,1806 # 16c0 <digits>
     fba:	a839                	j	fd8 <vprintf+0x6a>
        putc(fd, c);
     fbc:	85ca                	mv	a1,s2
     fbe:	8556                	mv	a0,s5
     fc0:	00000097          	auipc	ra,0x0
     fc4:	ee0080e7          	jalr	-288(ra) # ea0 <putc>
     fc8:	a019                	j	fce <vprintf+0x60>
    } else if(state == '%'){
     fca:	01498d63          	beq	s3,s4,fe4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     fce:	0485                	addi	s1,s1,1
     fd0:	fff4c903          	lbu	s2,-1(s1)
     fd4:	14090d63          	beqz	s2,112e <vprintf+0x1c0>
    if(state == 0){
     fd8:	fe0999e3          	bnez	s3,fca <vprintf+0x5c>
      if(c == '%'){
     fdc:	ff4910e3          	bne	s2,s4,fbc <vprintf+0x4e>
        state = '%';
     fe0:	89d2                	mv	s3,s4
     fe2:	b7f5                	j	fce <vprintf+0x60>
      if(c == 'd'){
     fe4:	11490c63          	beq	s2,s4,10fc <vprintf+0x18e>
     fe8:	f9d9079b          	addiw	a5,s2,-99
     fec:	0ff7f793          	zext.b	a5,a5
     ff0:	10fc6e63          	bltu	s8,a5,110c <vprintf+0x19e>
     ff4:	f9d9079b          	addiw	a5,s2,-99
     ff8:	0ff7f713          	zext.b	a4,a5
     ffc:	10ec6863          	bltu	s8,a4,110c <vprintf+0x19e>
    1000:	00271793          	slli	a5,a4,0x2
    1004:	97e6                	add	a5,a5,s9
    1006:	439c                	lw	a5,0(a5)
    1008:	97e6                	add	a5,a5,s9
    100a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    100c:	008b0913          	addi	s2,s6,8
    1010:	4685                	li	a3,1
    1012:	4629                	li	a2,10
    1014:	000b2583          	lw	a1,0(s6)
    1018:	8556                	mv	a0,s5
    101a:	00000097          	auipc	ra,0x0
    101e:	ea8080e7          	jalr	-344(ra) # ec2 <printint>
    1022:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1024:	4981                	li	s3,0
    1026:	b765                	j	fce <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1028:	008b0913          	addi	s2,s6,8
    102c:	4681                	li	a3,0
    102e:	4629                	li	a2,10
    1030:	000b2583          	lw	a1,0(s6)
    1034:	8556                	mv	a0,s5
    1036:	00000097          	auipc	ra,0x0
    103a:	e8c080e7          	jalr	-372(ra) # ec2 <printint>
    103e:	8b4a                	mv	s6,s2
      state = 0;
    1040:	4981                	li	s3,0
    1042:	b771                	j	fce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1044:	008b0913          	addi	s2,s6,8
    1048:	4681                	li	a3,0
    104a:	866a                	mv	a2,s10
    104c:	000b2583          	lw	a1,0(s6)
    1050:	8556                	mv	a0,s5
    1052:	00000097          	auipc	ra,0x0
    1056:	e70080e7          	jalr	-400(ra) # ec2 <printint>
    105a:	8b4a                	mv	s6,s2
      state = 0;
    105c:	4981                	li	s3,0
    105e:	bf85                	j	fce <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1060:	008b0793          	addi	a5,s6,8
    1064:	f8f43423          	sd	a5,-120(s0)
    1068:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    106c:	03000593          	li	a1,48
    1070:	8556                	mv	a0,s5
    1072:	00000097          	auipc	ra,0x0
    1076:	e2e080e7          	jalr	-466(ra) # ea0 <putc>
  putc(fd, 'x');
    107a:	07800593          	li	a1,120
    107e:	8556                	mv	a0,s5
    1080:	00000097          	auipc	ra,0x0
    1084:	e20080e7          	jalr	-480(ra) # ea0 <putc>
    1088:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    108a:	03c9d793          	srli	a5,s3,0x3c
    108e:	97de                	add	a5,a5,s7
    1090:	0007c583          	lbu	a1,0(a5)
    1094:	8556                	mv	a0,s5
    1096:	00000097          	auipc	ra,0x0
    109a:	e0a080e7          	jalr	-502(ra) # ea0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    109e:	0992                	slli	s3,s3,0x4
    10a0:	397d                	addiw	s2,s2,-1
    10a2:	fe0914e3          	bnez	s2,108a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    10a6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10aa:	4981                	li	s3,0
    10ac:	b70d                	j	fce <vprintf+0x60>
        s = va_arg(ap, char*);
    10ae:	008b0913          	addi	s2,s6,8
    10b2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    10b6:	02098163          	beqz	s3,10d8 <vprintf+0x16a>
        while(*s != 0){
    10ba:	0009c583          	lbu	a1,0(s3)
    10be:	c5ad                	beqz	a1,1128 <vprintf+0x1ba>
          putc(fd, *s);
    10c0:	8556                	mv	a0,s5
    10c2:	00000097          	auipc	ra,0x0
    10c6:	dde080e7          	jalr	-546(ra) # ea0 <putc>
          s++;
    10ca:	0985                	addi	s3,s3,1
        while(*s != 0){
    10cc:	0009c583          	lbu	a1,0(s3)
    10d0:	f9e5                	bnez	a1,10c0 <vprintf+0x152>
        s = va_arg(ap, char*);
    10d2:	8b4a                	mv	s6,s2
      state = 0;
    10d4:	4981                	li	s3,0
    10d6:	bde5                	j	fce <vprintf+0x60>
          s = "(null)";
    10d8:	00000997          	auipc	s3,0x0
    10dc:	58898993          	addi	s3,s3,1416 # 1660 <malloc+0x42e>
        while(*s != 0){
    10e0:	85ee                	mv	a1,s11
    10e2:	bff9                	j	10c0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    10e4:	008b0913          	addi	s2,s6,8
    10e8:	000b4583          	lbu	a1,0(s6)
    10ec:	8556                	mv	a0,s5
    10ee:	00000097          	auipc	ra,0x0
    10f2:	db2080e7          	jalr	-590(ra) # ea0 <putc>
    10f6:	8b4a                	mv	s6,s2
      state = 0;
    10f8:	4981                	li	s3,0
    10fa:	bdd1                	j	fce <vprintf+0x60>
        putc(fd, c);
    10fc:	85d2                	mv	a1,s4
    10fe:	8556                	mv	a0,s5
    1100:	00000097          	auipc	ra,0x0
    1104:	da0080e7          	jalr	-608(ra) # ea0 <putc>
      state = 0;
    1108:	4981                	li	s3,0
    110a:	b5d1                	j	fce <vprintf+0x60>
        putc(fd, '%');
    110c:	85d2                	mv	a1,s4
    110e:	8556                	mv	a0,s5
    1110:	00000097          	auipc	ra,0x0
    1114:	d90080e7          	jalr	-624(ra) # ea0 <putc>
        putc(fd, c);
    1118:	85ca                	mv	a1,s2
    111a:	8556                	mv	a0,s5
    111c:	00000097          	auipc	ra,0x0
    1120:	d84080e7          	jalr	-636(ra) # ea0 <putc>
      state = 0;
    1124:	4981                	li	s3,0
    1126:	b565                	j	fce <vprintf+0x60>
        s = va_arg(ap, char*);
    1128:	8b4a                	mv	s6,s2
      state = 0;
    112a:	4981                	li	s3,0
    112c:	b54d                	j	fce <vprintf+0x60>
    }
  }
}
    112e:	70e6                	ld	ra,120(sp)
    1130:	7446                	ld	s0,112(sp)
    1132:	74a6                	ld	s1,104(sp)
    1134:	7906                	ld	s2,96(sp)
    1136:	69e6                	ld	s3,88(sp)
    1138:	6a46                	ld	s4,80(sp)
    113a:	6aa6                	ld	s5,72(sp)
    113c:	6b06                	ld	s6,64(sp)
    113e:	7be2                	ld	s7,56(sp)
    1140:	7c42                	ld	s8,48(sp)
    1142:	7ca2                	ld	s9,40(sp)
    1144:	7d02                	ld	s10,32(sp)
    1146:	6de2                	ld	s11,24(sp)
    1148:	6109                	addi	sp,sp,128
    114a:	8082                	ret

000000000000114c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    114c:	715d                	addi	sp,sp,-80
    114e:	ec06                	sd	ra,24(sp)
    1150:	e822                	sd	s0,16(sp)
    1152:	1000                	addi	s0,sp,32
    1154:	e010                	sd	a2,0(s0)
    1156:	e414                	sd	a3,8(s0)
    1158:	e818                	sd	a4,16(s0)
    115a:	ec1c                	sd	a5,24(s0)
    115c:	03043023          	sd	a6,32(s0)
    1160:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1164:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1168:	8622                	mv	a2,s0
    116a:	00000097          	auipc	ra,0x0
    116e:	e04080e7          	jalr	-508(ra) # f6e <vprintf>
}
    1172:	60e2                	ld	ra,24(sp)
    1174:	6442                	ld	s0,16(sp)
    1176:	6161                	addi	sp,sp,80
    1178:	8082                	ret

000000000000117a <printf>:

void
printf(const char *fmt, ...)
{
    117a:	711d                	addi	sp,sp,-96
    117c:	ec06                	sd	ra,24(sp)
    117e:	e822                	sd	s0,16(sp)
    1180:	1000                	addi	s0,sp,32
    1182:	e40c                	sd	a1,8(s0)
    1184:	e810                	sd	a2,16(s0)
    1186:	ec14                	sd	a3,24(s0)
    1188:	f018                	sd	a4,32(s0)
    118a:	f41c                	sd	a5,40(s0)
    118c:	03043823          	sd	a6,48(s0)
    1190:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1194:	00840613          	addi	a2,s0,8
    1198:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    119c:	85aa                	mv	a1,a0
    119e:	4505                	li	a0,1
    11a0:	00000097          	auipc	ra,0x0
    11a4:	dce080e7          	jalr	-562(ra) # f6e <vprintf>
}
    11a8:	60e2                	ld	ra,24(sp)
    11aa:	6442                	ld	s0,16(sp)
    11ac:	6125                	addi	sp,sp,96
    11ae:	8082                	ret

00000000000011b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11b0:	1141                	addi	sp,sp,-16
    11b2:	e422                	sd	s0,8(sp)
    11b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ba:	00000797          	auipc	a5,0x0
    11be:	5267b783          	ld	a5,1318(a5) # 16e0 <freep>
    11c2:	a02d                	j	11ec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11c4:	4618                	lw	a4,8(a2)
    11c6:	9f2d                	addw	a4,a4,a1
    11c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11cc:	6398                	ld	a4,0(a5)
    11ce:	6310                	ld	a2,0(a4)
    11d0:	a83d                	j	120e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11d2:	ff852703          	lw	a4,-8(a0)
    11d6:	9f31                	addw	a4,a4,a2
    11d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11da:	ff053683          	ld	a3,-16(a0)
    11de:	a091                	j	1222 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11e0:	6398                	ld	a4,0(a5)
    11e2:	00e7e463          	bltu	a5,a4,11ea <free+0x3a>
    11e6:	00e6ea63          	bltu	a3,a4,11fa <free+0x4a>
{
    11ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ec:	fed7fae3          	bgeu	a5,a3,11e0 <free+0x30>
    11f0:	6398                	ld	a4,0(a5)
    11f2:	00e6e463          	bltu	a3,a4,11fa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f6:	fee7eae3          	bltu	a5,a4,11ea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11fa:	ff852583          	lw	a1,-8(a0)
    11fe:	6390                	ld	a2,0(a5)
    1200:	02059813          	slli	a6,a1,0x20
    1204:	01c85713          	srli	a4,a6,0x1c
    1208:	9736                	add	a4,a4,a3
    120a:	fae60de3          	beq	a2,a4,11c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    120e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1212:	4790                	lw	a2,8(a5)
    1214:	02061593          	slli	a1,a2,0x20
    1218:	01c5d713          	srli	a4,a1,0x1c
    121c:	973e                	add	a4,a4,a5
    121e:	fae68ae3          	beq	a3,a4,11d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1222:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1224:	00000717          	auipc	a4,0x0
    1228:	4af73e23          	sd	a5,1212(a4) # 16e0 <freep>
}
    122c:	6422                	ld	s0,8(sp)
    122e:	0141                	addi	sp,sp,16
    1230:	8082                	ret

0000000000001232 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1232:	7139                	addi	sp,sp,-64
    1234:	fc06                	sd	ra,56(sp)
    1236:	f822                	sd	s0,48(sp)
    1238:	f426                	sd	s1,40(sp)
    123a:	f04a                	sd	s2,32(sp)
    123c:	ec4e                	sd	s3,24(sp)
    123e:	e852                	sd	s4,16(sp)
    1240:	e456                	sd	s5,8(sp)
    1242:	e05a                	sd	s6,0(sp)
    1244:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1246:	02051493          	slli	s1,a0,0x20
    124a:	9081                	srli	s1,s1,0x20
    124c:	04bd                	addi	s1,s1,15
    124e:	8091                	srli	s1,s1,0x4
    1250:	0014899b          	addiw	s3,s1,1
    1254:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1256:	00000517          	auipc	a0,0x0
    125a:	48a53503          	ld	a0,1162(a0) # 16e0 <freep>
    125e:	c515                	beqz	a0,128a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1260:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1262:	4798                	lw	a4,8(a5)
    1264:	02977f63          	bgeu	a4,s1,12a2 <malloc+0x70>
    1268:	8a4e                	mv	s4,s3
    126a:	0009871b          	sext.w	a4,s3
    126e:	6685                	lui	a3,0x1
    1270:	00d77363          	bgeu	a4,a3,1276 <malloc+0x44>
    1274:	6a05                	lui	s4,0x1
    1276:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    127a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    127e:	00000917          	auipc	s2,0x0
    1282:	46290913          	addi	s2,s2,1122 # 16e0 <freep>
  if(p == (char*)-1)
    1286:	5afd                	li	s5,-1
    1288:	a895                	j	12fc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    128a:	00001797          	auipc	a5,0x1
    128e:	84678793          	addi	a5,a5,-1978 # 1ad0 <base>
    1292:	00000717          	auipc	a4,0x0
    1296:	44f73723          	sd	a5,1102(a4) # 16e0 <freep>
    129a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    129c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12a0:	b7e1                	j	1268 <malloc+0x36>
      if(p->s.size == nunits)
    12a2:	02e48c63          	beq	s1,a4,12da <malloc+0xa8>
        p->s.size -= nunits;
    12a6:	4137073b          	subw	a4,a4,s3
    12aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12ac:	02071693          	slli	a3,a4,0x20
    12b0:	01c6d713          	srli	a4,a3,0x1c
    12b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12ba:	00000717          	auipc	a4,0x0
    12be:	42a73323          	sd	a0,1062(a4) # 16e0 <freep>
      return (void*)(p + 1);
    12c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12c6:	70e2                	ld	ra,56(sp)
    12c8:	7442                	ld	s0,48(sp)
    12ca:	74a2                	ld	s1,40(sp)
    12cc:	7902                	ld	s2,32(sp)
    12ce:	69e2                	ld	s3,24(sp)
    12d0:	6a42                	ld	s4,16(sp)
    12d2:	6aa2                	ld	s5,8(sp)
    12d4:	6b02                	ld	s6,0(sp)
    12d6:	6121                	addi	sp,sp,64
    12d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12da:	6398                	ld	a4,0(a5)
    12dc:	e118                	sd	a4,0(a0)
    12de:	bff1                	j	12ba <malloc+0x88>
  hp->s.size = nu;
    12e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12e4:	0541                	addi	a0,a0,16
    12e6:	00000097          	auipc	ra,0x0
    12ea:	eca080e7          	jalr	-310(ra) # 11b0 <free>
  return freep;
    12ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12f2:	d971                	beqz	a0,12c6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12f6:	4798                	lw	a4,8(a5)
    12f8:	fa9775e3          	bgeu	a4,s1,12a2 <malloc+0x70>
    if(p == freep)
    12fc:	00093703          	ld	a4,0(s2)
    1300:	853e                	mv	a0,a5
    1302:	fef719e3          	bne	a4,a5,12f4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1306:	8552                	mv	a0,s4
    1308:	00000097          	auipc	ra,0x0
    130c:	b80080e7          	jalr	-1152(ra) # e88 <sbrk>
  if(p == (char*)-1)
    1310:	fd5518e3          	bne	a0,s5,12e0 <malloc+0xae>
        return 0;
    1314:	4501                	li	a0,0
    1316:	bf45                	j	12c6 <malloc+0x94>
