
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9f013103          	ld	sp,-1552(sp) # 800089f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	68c050ef          	jal	ra,800056a2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	02e080e7          	jalr	46(ra) # 80006088 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	0ce080e7          	jalr	206(ra) # 8000613c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ac6080e7          	jalr	-1338(ra) # 80005b50 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	f02080e7          	jalr	-254(ra) # 80005ff8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	f5a080e7          	jalr	-166(ra) # 80006088 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	ff6080e7          	jalr	-10(ra) # 8000613c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	fcc080e7          	jalr	-52(ra) # 8000613c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	af0080e7          	jalr	-1296(ra) # 80000e18 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ad4080e7          	jalr	-1324(ra) # 80000e18 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	844080e7          	jalr	-1980(ra) # 80005b9a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	73c080e7          	jalr	1852(ra) # 80001aa2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	d12080e7          	jalr	-750(ra) # 80005080 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fe8080e7          	jalr	-24(ra) # 8000135e <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	6e2080e7          	jalr	1762(ra) # 80005a60 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	9f4080e7          	jalr	-1548(ra) # 80005d7a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	804080e7          	jalr	-2044(ra) # 80005b9a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00005097          	auipc	ra,0x5
    800003aa:	7f4080e7          	jalr	2036(ra) # 80005b9a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	7e4080e7          	jalr	2020(ra) # 80005b9a <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	69c080e7          	jalr	1692(ra) # 80001a7a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6bc080e7          	jalr	1724(ra) # 80001aa2 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	c7c080e7          	jalr	-900(ra) # 8000506a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	c8a080e7          	jalr	-886(ra) # 80005080 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	e50080e7          	jalr	-432(ra) # 8000224e <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	4de080e7          	jalr	1246(ra) # 800028e4 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	490080e7          	jalr	1168(ra) # 8000389e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	d8a080e7          	jalr	-630(ra) # 800051a0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cfe080e7          	jalr	-770(ra) # 8000111c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00005097          	auipc	ra,0x5
    8000048c:	6c8080e7          	jalr	1736(ra) # 80005b50 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	5a2080e7          	jalr	1442(ra) # 80005b50 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	592080e7          	jalr	1426(ra) # 80005b50 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	546080e7          	jalr	1350(ra) # 80005b50 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	3fa080e7          	jalr	1018(ra) # 80005b50 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	3ea080e7          	jalr	1002(ra) # 80005b50 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	3da080e7          	jalr	986(ra) # 80005b50 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	3ca080e7          	jalr	970(ra) # 80005b50 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	2ec080e7          	jalr	748(ra) # 80005b50 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	1a8080e7          	jalr	424(ra) # 80005b50 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	0ca080e7          	jalr	202(ra) # 80005b50 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	0ba080e7          	jalr	186(ra) # 80005b50 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	050080e7          	jalr	80(ra) # 80005b50 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000ea17          	auipc	s4,0xe
    80000d06:	17ea0a13          	addi	s4,s4,382 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	858d                	srai	a1,a1,0x3
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	16848493          	addi	s1,s1,360
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	df0080e7          	jalr	-528(ra) # 80005b50 <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	26c080e7          	jalr	620(ra) # 80005ff8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	254080e7          	jalr	596(ra) # 80005ff8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	0000e997          	auipc	s3,0xe
    80000dd2:	0b298993          	addi	s3,s3,178 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	21e080e7          	jalr	542(ra) # 80005ff8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	878d                	srai	a5,a5,0x3
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	16848493          	addi	s1,s1,360
    80000e00:	fd349be3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	1ee080e7          	jalr	494(ra) # 8000603c <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	274080e7          	jalr	628(ra) # 800060dc <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	2b0080e7          	jalr	688(ra) # 8000613c <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	a4c7a783          	lw	a5,-1460(a5) # 800088e0 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c1c080e7          	jalr	-996(ra) # 80001aba <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	a207a923          	sw	zero,-1486(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	9ac080e7          	jalr	-1620(ra) # 80002864 <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	1b0080e7          	jalr	432(ra) # 80006088 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	a0478793          	addi	a5,a5,-1532 # 800088e4 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	24a080e7          	jalr	586(ra) # 8000613c <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8b6080e7          	jalr	-1866(ra) # 800007cc <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	60c080e7          	jalr	1548(ra) # 80000542 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5ee080e7          	jalr	1518(ra) # 80000542 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a58080e7          	jalr	-1448(ra) # 800009ca <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	77c080e7          	jalr	1916(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a32080e7          	jalr	-1486(ra) # 800009ca <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	748080e7          	jalr	1864(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	732080e7          	jalr	1842(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9e8080e7          	jalr	-1560(ra) # 800009ca <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	0000e917          	auipc	s2,0xe
    80001066:	e1e90913          	addi	s2,s2,-482 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	01c080e7          	jalr	28(ra) # 80006088 <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cf81                	beqz	a5,8000108e <allocproc+0x40>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	0c2080e7          	jalr	194(ra) # 8000613c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	16848493          	addi	s1,s1,360
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	a889                	j	800010de <allocproc+0x90>
  p->pid = allocpid();
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	e34080e7          	jalr	-460(ra) # 80000ec2 <allocpid>
    80001096:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001098:	4785                	li	a5,1
    8000109a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	07e080e7          	jalr	126(ra) # 8000011a <kalloc>
    800010a4:	892a                	mv	s2,a0
    800010a6:	eca8                	sd	a0,88(s1)
    800010a8:	c131                	beqz	a0,800010ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e5c080e7          	jalr	-420(ra) # 80000f08 <proc_pagetable>
    800010b4:	892a                	mv	s2,a0
    800010b6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b8:	c531                	beqz	a0,80001104 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ba:	07000613          	li	a2,112
    800010be:	4581                	li	a1,0
    800010c0:	06048513          	addi	a0,s1,96
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	0b6080e7          	jalr	182(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010cc:	00000797          	auipc	a5,0x0
    800010d0:	db078793          	addi	a5,a5,-592 # 80000e7c <forkret>
    800010d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d6:	60bc                	ld	a5,64(s1)
    800010d8:	6705                	lui	a4,0x1
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	f4bc                	sd	a5,104(s1)
}
    800010de:	8526                	mv	a0,s1
    800010e0:	60e2                	ld	ra,24(sp)
    800010e2:	6442                	ld	s0,16(sp)
    800010e4:	64a2                	ld	s1,8(sp)
    800010e6:	6902                	ld	s2,0(sp)
    800010e8:	6105                	addi	sp,sp,32
    800010ea:	8082                	ret
    freeproc(p);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f08080e7          	jalr	-248(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	044080e7          	jalr	68(ra) # 8000613c <release>
    return 0;
    80001100:	84ca                	mv	s1,s2
    80001102:	bff1                	j	800010de <allocproc+0x90>
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	ef0080e7          	jalr	-272(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	02c080e7          	jalr	44(ra) # 8000613c <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	b7d1                	j	800010de <allocproc+0x90>

000000008000111c <userinit>:
{
    8000111c:	1101                	addi	sp,sp,-32
    8000111e:	ec06                	sd	ra,24(sp)
    80001120:	e822                	sd	s0,16(sp)
    80001122:	e426                	sd	s1,8(sp)
    80001124:	1000                	addi	s0,sp,32
  p = allocproc();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f28080e7          	jalr	-216(ra) # 8000104e <allocproc>
    8000112e:	84aa                	mv	s1,a0
  initproc = p;
    80001130:	00008797          	auipc	a5,0x8
    80001134:	eea7b023          	sd	a0,-288(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001138:	03400613          	li	a2,52
    8000113c:	00007597          	auipc	a1,0x7
    80001140:	7b458593          	addi	a1,a1,1972 # 800088f0 <initcode>
    80001144:	6928                	ld	a0,80(a0)
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	6b4080e7          	jalr	1716(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000114e:	6785                	lui	a5,0x1
    80001150:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001158:	6cb8                	ld	a4,88(s1)
    8000115a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115c:	4641                	li	a2,16
    8000115e:	00007597          	auipc	a1,0x7
    80001162:	02258593          	addi	a1,a1,34 # 80008180 <etext+0x180>
    80001166:	15848513          	addi	a0,s1,344
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	15a080e7          	jalr	346(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	01e50513          	addi	a0,a0,30 # 80008190 <etext+0x190>
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	120080e7          	jalr	288(ra) # 8000329a <namei>
    80001182:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001186:	478d                	li	a5,3
    80001188:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	fb0080e7          	jalr	-80(ra) # 8000613c <release>
}
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <growproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	e04a                	sd	s2,0(sp)
    800011a8:	1000                	addi	s0,sp,32
    800011aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c98080e7          	jalr	-872(ra) # 80000e44 <myproc>
    800011b4:	892a                	mv	s2,a0
  sz = p->sz;
    800011b6:	652c                	ld	a1,72(a0)
    800011b8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011bc:	00904f63          	bgtz	s1,800011da <growproc+0x3c>
  } else if(n < 0){
    800011c0:	0204cd63          	bltz	s1,800011fa <growproc+0x5c>
  p->sz = sz;
    800011c4:	1782                	slli	a5,a5,0x20
    800011c6:	9381                	srli	a5,a5,0x20
    800011c8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011cc:	4501                	li	a0,0
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011da:	00f4863b          	addw	a2,s1,a5
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	1582                	slli	a1,a1,0x20
    800011e4:	9181                	srli	a1,a1,0x20
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6cc080e7          	jalr	1740(ra) # 800008b4 <uvmalloc>
    800011f0:	0005079b          	sext.w	a5,a0
    800011f4:	fbe1                	bnez	a5,800011c4 <growproc+0x26>
      return -1;
    800011f6:	557d                	li	a0,-1
    800011f8:	bfd9                	j	800011ce <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fa:	00f4863b          	addw	a2,s1,a5
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	664080e7          	jalr	1636(ra) # 8000086c <uvmdealloc>
    80001210:	0005079b          	sext.w	a5,a0
    80001214:	bf45                	j	800011c4 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c1c080e7          	jalr	-996(ra) # 80000e44 <myproc>
    80001230:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e1c080e7          	jalr	-484(ra) # 8000104e <allocproc>
    8000123a:	12050063          	beqz	a0,8000135a <fork+0x144>
    8000123e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001240:	048ab603          	ld	a2,72(s5)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	050ab503          	ld	a0,80(s5)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7ba080e7          	jalr	1978(ra) # 80000a04 <uvmcopy>
    80001252:	04054863          	bltz	a0,800012a2 <fork+0x8c>
  np->sz = p->sz;
    80001256:	048ab783          	ld	a5,72(s5)
    8000125a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125e:	058ab683          	ld	a3,88(s5)
    80001262:	87b6                	mv	a5,a3
    80001264:	0589b703          	ld	a4,88(s3)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x56>
  np->trapframe->a0 = 0;
    8000128c:	0589b783          	ld	a5,88(s3)
    80001290:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001294:	0d0a8493          	addi	s1,s5,208
    80001298:	0d098913          	addi	s2,s3,208
    8000129c:	150a8a13          	addi	s4,s5,336
    800012a0:	a00d                	j	800012c2 <fork+0xac>
    freeproc(np);
    800012a2:	854e                	mv	a0,s3
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	d52080e7          	jalr	-686(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012ac:	854e                	mv	a0,s3
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	e8e080e7          	jalr	-370(ra) # 8000613c <release>
    return -1;
    800012b6:	597d                	li	s2,-1
    800012b8:	a079                	j	80001346 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	0921                	addi	s2,s2,8
    800012be:	01448b63          	beq	s1,s4,800012d4 <fork+0xbe>
    if(p->ofile[i])
    800012c2:	6088                	ld	a0,0(s1)
    800012c4:	d97d                	beqz	a0,800012ba <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c6:	00002097          	auipc	ra,0x2
    800012ca:	66a080e7          	jalr	1642(ra) # 80003930 <filedup>
    800012ce:	00a93023          	sd	a0,0(s2)
    800012d2:	b7e5                	j	800012ba <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012d4:	150ab503          	ld	a0,336(s5)
    800012d8:	00001097          	auipc	ra,0x1
    800012dc:	7c8080e7          	jalr	1992(ra) # 80002aa0 <idup>
    800012e0:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e4:	4641                	li	a2,16
    800012e6:	158a8593          	addi	a1,s5,344
    800012ea:	15898513          	addi	a0,s3,344
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	fd6080e7          	jalr	-42(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012f6:	0309a903          	lw	s2,48(s3)
  np->mask = p->mask;
    800012fa:	034aa783          	lw	a5,52(s5)
    800012fe:	02f9aa23          	sw	a5,52(s3)
  release(&np->lock);
    80001302:	854e                	mv	a0,s3
    80001304:	00005097          	auipc	ra,0x5
    80001308:	e38080e7          	jalr	-456(ra) # 8000613c <release>
  acquire(&wait_lock);
    8000130c:	00008497          	auipc	s1,0x8
    80001310:	d5c48493          	addi	s1,s1,-676 # 80009068 <wait_lock>
    80001314:	8526                	mv	a0,s1
    80001316:	00005097          	auipc	ra,0x5
    8000131a:	d72080e7          	jalr	-654(ra) # 80006088 <acquire>
  np->parent = p;
    8000131e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001322:	8526                	mv	a0,s1
    80001324:	00005097          	auipc	ra,0x5
    80001328:	e18080e7          	jalr	-488(ra) # 8000613c <release>
  acquire(&np->lock);
    8000132c:	854e                	mv	a0,s3
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	d5a080e7          	jalr	-678(ra) # 80006088 <acquire>
  np->state = RUNNABLE;
    80001336:	478d                	li	a5,3
    80001338:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000133c:	854e                	mv	a0,s3
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	dfe080e7          	jalr	-514(ra) # 8000613c <release>
}
    80001346:	854a                	mv	a0,s2
    80001348:	70e2                	ld	ra,56(sp)
    8000134a:	7442                	ld	s0,48(sp)
    8000134c:	74a2                	ld	s1,40(sp)
    8000134e:	7902                	ld	s2,32(sp)
    80001350:	69e2                	ld	s3,24(sp)
    80001352:	6a42                	ld	s4,16(sp)
    80001354:	6aa2                	ld	s5,8(sp)
    80001356:	6121                	addi	sp,sp,64
    80001358:	8082                	ret
    return -1;
    8000135a:	597d                	li	s2,-1
    8000135c:	b7ed                	j	80001346 <fork+0x130>

000000008000135e <scheduler>:
{
    8000135e:	7139                	addi	sp,sp,-64
    80001360:	fc06                	sd	ra,56(sp)
    80001362:	f822                	sd	s0,48(sp)
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	ec4e                	sd	s3,24(sp)
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	e456                	sd	s5,8(sp)
    8000136e:	e05a                	sd	s6,0(sp)
    80001370:	0080                	addi	s0,sp,64
    80001372:	8792                	mv	a5,tp
  int id = r_tp();
    80001374:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001376:	00779a93          	slli	s5,a5,0x7
    8000137a:	00008717          	auipc	a4,0x8
    8000137e:	cd670713          	addi	a4,a4,-810 # 80009050 <pid_lock>
    80001382:	9756                	add	a4,a4,s5
    80001384:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001388:	00008717          	auipc	a4,0x8
    8000138c:	d0070713          	addi	a4,a4,-768 # 80009088 <cpus+0x8>
    80001390:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001392:	498d                	li	s3,3
        p->state = RUNNING;
    80001394:	4b11                	li	s6,4
        c->proc = p;
    80001396:	079e                	slli	a5,a5,0x7
    80001398:	00008a17          	auipc	s4,0x8
    8000139c:	cb8a0a13          	addi	s4,s4,-840 # 80009050 <pid_lock>
    800013a0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a2:	0000e917          	auipc	s2,0xe
    800013a6:	ade90913          	addi	s2,s2,-1314 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b2:	10079073          	csrw	sstatus,a5
    800013b6:	00008497          	auipc	s1,0x8
    800013ba:	0ca48493          	addi	s1,s1,202 # 80009480 <proc>
    800013be:	a811                	j	800013d2 <scheduler+0x74>
      release(&p->lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	d7a080e7          	jalr	-646(ra) # 8000613c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ca:	16848493          	addi	s1,s1,360
    800013ce:	fd248ee3          	beq	s1,s2,800013aa <scheduler+0x4c>
      acquire(&p->lock);
    800013d2:	8526                	mv	a0,s1
    800013d4:	00005097          	auipc	ra,0x5
    800013d8:	cb4080e7          	jalr	-844(ra) # 80006088 <acquire>
      if(p->state == RUNNABLE) {
    800013dc:	4c9c                	lw	a5,24(s1)
    800013de:	ff3791e3          	bne	a5,s3,800013c0 <scheduler+0x62>
        p->state = RUNNING;
    800013e2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013e6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ea:	06048593          	addi	a1,s1,96
    800013ee:	8556                	mv	a0,s5
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	620080e7          	jalr	1568(ra) # 80001a10 <swtch>
        c->proc = 0;
    800013f8:	020a3823          	sd	zero,48(s4)
    800013fc:	b7d1                	j	800013c0 <scheduler+0x62>

00000000800013fe <sched>:
{
    800013fe:	7179                	addi	sp,sp,-48
    80001400:	f406                	sd	ra,40(sp)
    80001402:	f022                	sd	s0,32(sp)
    80001404:	ec26                	sd	s1,24(sp)
    80001406:	e84a                	sd	s2,16(sp)
    80001408:	e44e                	sd	s3,8(sp)
    8000140a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	a38080e7          	jalr	-1480(ra) # 80000e44 <myproc>
    80001414:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001416:	00005097          	auipc	ra,0x5
    8000141a:	bf8080e7          	jalr	-1032(ra) # 8000600e <holding>
    8000141e:	c93d                	beqz	a0,80001494 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001420:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001422:	2781                	sext.w	a5,a5
    80001424:	079e                	slli	a5,a5,0x7
    80001426:	00008717          	auipc	a4,0x8
    8000142a:	c2a70713          	addi	a4,a4,-982 # 80009050 <pid_lock>
    8000142e:	97ba                	add	a5,a5,a4
    80001430:	0a87a703          	lw	a4,168(a5)
    80001434:	4785                	li	a5,1
    80001436:	06f71763          	bne	a4,a5,800014a4 <sched+0xa6>
  if(p->state == RUNNING)
    8000143a:	4c98                	lw	a4,24(s1)
    8000143c:	4791                	li	a5,4
    8000143e:	06f70b63          	beq	a4,a5,800014b4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001442:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001446:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001448:	efb5                	bnez	a5,800014c4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000144c:	00008917          	auipc	s2,0x8
    80001450:	c0490913          	addi	s2,s2,-1020 # 80009050 <pid_lock>
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	97ca                	add	a5,a5,s2
    8000145a:	0ac7a983          	lw	s3,172(a5)
    8000145e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001460:	2781                	sext.w	a5,a5
    80001462:	079e                	slli	a5,a5,0x7
    80001464:	00008597          	auipc	a1,0x8
    80001468:	c2458593          	addi	a1,a1,-988 # 80009088 <cpus+0x8>
    8000146c:	95be                	add	a1,a1,a5
    8000146e:	06048513          	addi	a0,s1,96
    80001472:	00000097          	auipc	ra,0x0
    80001476:	59e080e7          	jalr	1438(ra) # 80001a10 <swtch>
    8000147a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000147c:	2781                	sext.w	a5,a5
    8000147e:	079e                	slli	a5,a5,0x7
    80001480:	993e                	add	s2,s2,a5
    80001482:	0b392623          	sw	s3,172(s2)
}
    80001486:	70a2                	ld	ra,40(sp)
    80001488:	7402                	ld	s0,32(sp)
    8000148a:	64e2                	ld	s1,24(sp)
    8000148c:	6942                	ld	s2,16(sp)
    8000148e:	69a2                	ld	s3,8(sp)
    80001490:	6145                	addi	sp,sp,48
    80001492:	8082                	ret
    panic("sched p->lock");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	d0450513          	addi	a0,a0,-764 # 80008198 <etext+0x198>
    8000149c:	00004097          	auipc	ra,0x4
    800014a0:	6b4080e7          	jalr	1716(ra) # 80005b50 <panic>
    panic("sched locks");
    800014a4:	00007517          	auipc	a0,0x7
    800014a8:	d0450513          	addi	a0,a0,-764 # 800081a8 <etext+0x1a8>
    800014ac:	00004097          	auipc	ra,0x4
    800014b0:	6a4080e7          	jalr	1700(ra) # 80005b50 <panic>
    panic("sched running");
    800014b4:	00007517          	auipc	a0,0x7
    800014b8:	d0450513          	addi	a0,a0,-764 # 800081b8 <etext+0x1b8>
    800014bc:	00004097          	auipc	ra,0x4
    800014c0:	694080e7          	jalr	1684(ra) # 80005b50 <panic>
    panic("sched interruptible");
    800014c4:	00007517          	auipc	a0,0x7
    800014c8:	d0450513          	addi	a0,a0,-764 # 800081c8 <etext+0x1c8>
    800014cc:	00004097          	auipc	ra,0x4
    800014d0:	684080e7          	jalr	1668(ra) # 80005b50 <panic>

00000000800014d4 <yield>:
{
    800014d4:	1101                	addi	sp,sp,-32
    800014d6:	ec06                	sd	ra,24(sp)
    800014d8:	e822                	sd	s0,16(sp)
    800014da:	e426                	sd	s1,8(sp)
    800014dc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	966080e7          	jalr	-1690(ra) # 80000e44 <myproc>
    800014e6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	ba0080e7          	jalr	-1120(ra) # 80006088 <acquire>
  p->state = RUNNABLE;
    800014f0:	478d                	li	a5,3
    800014f2:	cc9c                	sw	a5,24(s1)
  sched();
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	f0a080e7          	jalr	-246(ra) # 800013fe <sched>
  release(&p->lock);
    800014fc:	8526                	mv	a0,s1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	c3e080e7          	jalr	-962(ra) # 8000613c <release>
}
    80001506:	60e2                	ld	ra,24(sp)
    80001508:	6442                	ld	s0,16(sp)
    8000150a:	64a2                	ld	s1,8(sp)
    8000150c:	6105                	addi	sp,sp,32
    8000150e:	8082                	ret

0000000080001510 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001510:	7179                	addi	sp,sp,-48
    80001512:	f406                	sd	ra,40(sp)
    80001514:	f022                	sd	s0,32(sp)
    80001516:	ec26                	sd	s1,24(sp)
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
    8000151c:	1800                	addi	s0,sp,48
    8000151e:	89aa                	mv	s3,a0
    80001520:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	922080e7          	jalr	-1758(ra) # 80000e44 <myproc>
    8000152a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	b5c080e7          	jalr	-1188(ra) # 80006088 <acquire>
  release(lk);
    80001534:	854a                	mv	a0,s2
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	c06080e7          	jalr	-1018(ra) # 8000613c <release>

  // Go to sleep.
  p->chan = chan;
    8000153e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001542:	4789                	li	a5,2
    80001544:	cc9c                	sw	a5,24(s1)

  sched();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	eb8080e7          	jalr	-328(ra) # 800013fe <sched>

  // Tidy up.
  p->chan = 0;
    8000154e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	00005097          	auipc	ra,0x5
    80001558:	be8080e7          	jalr	-1048(ra) # 8000613c <release>
  acquire(lk);
    8000155c:	854a                	mv	a0,s2
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	b2a080e7          	jalr	-1238(ra) # 80006088 <acquire>
}
    80001566:	70a2                	ld	ra,40(sp)
    80001568:	7402                	ld	s0,32(sp)
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret

0000000080001574 <wait>:
{
    80001574:	715d                	addi	sp,sp,-80
    80001576:	e486                	sd	ra,72(sp)
    80001578:	e0a2                	sd	s0,64(sp)
    8000157a:	fc26                	sd	s1,56(sp)
    8000157c:	f84a                	sd	s2,48(sp)
    8000157e:	f44e                	sd	s3,40(sp)
    80001580:	f052                	sd	s4,32(sp)
    80001582:	ec56                	sd	s5,24(sp)
    80001584:	e85a                	sd	s6,16(sp)
    80001586:	e45e                	sd	s7,8(sp)
    80001588:	e062                	sd	s8,0(sp)
    8000158a:	0880                	addi	s0,sp,80
    8000158c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	8b6080e7          	jalr	-1866(ra) # 80000e44 <myproc>
    80001596:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001598:	00008517          	auipc	a0,0x8
    8000159c:	ad050513          	addi	a0,a0,-1328 # 80009068 <wait_lock>
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	ae8080e7          	jalr	-1304(ra) # 80006088 <acquire>
    havekids = 0;
    800015a8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015aa:	4a15                	li	s4,5
        havekids = 1;
    800015ac:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015ae:	0000e997          	auipc	s3,0xe
    800015b2:	8d298993          	addi	s3,s3,-1838 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b6:	00008c17          	auipc	s8,0x8
    800015ba:	ab2c0c13          	addi	s8,s8,-1358 # 80009068 <wait_lock>
    havekids = 0;
    800015be:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c0:	00008497          	auipc	s1,0x8
    800015c4:	ec048493          	addi	s1,s1,-320 # 80009480 <proc>
    800015c8:	a0bd                	j	80001636 <wait+0xc2>
          pid = np->pid;
    800015ca:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ce:	000b0e63          	beqz	s6,800015ea <wait+0x76>
    800015d2:	4691                	li	a3,4
    800015d4:	02c48613          	addi	a2,s1,44
    800015d8:	85da                	mv	a1,s6
    800015da:	05093503          	ld	a0,80(s2)
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	52a080e7          	jalr	1322(ra) # 80000b08 <copyout>
    800015e6:	02054563          	bltz	a0,80001610 <wait+0x9c>
          freeproc(np);
    800015ea:	8526                	mv	a0,s1
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	a0a080e7          	jalr	-1526(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015f4:	8526                	mv	a0,s1
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	b46080e7          	jalr	-1210(ra) # 8000613c <release>
          release(&wait_lock);
    800015fe:	00008517          	auipc	a0,0x8
    80001602:	a6a50513          	addi	a0,a0,-1430 # 80009068 <wait_lock>
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	b36080e7          	jalr	-1226(ra) # 8000613c <release>
          return pid;
    8000160e:	a09d                	j	80001674 <wait+0x100>
            release(&np->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	b2a080e7          	jalr	-1238(ra) # 8000613c <release>
            release(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	b1a080e7          	jalr	-1254(ra) # 8000613c <release>
            return -1;
    8000162a:	59fd                	li	s3,-1
    8000162c:	a0a1                	j	80001674 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000162e:	16848493          	addi	s1,s1,360
    80001632:	03348463          	beq	s1,s3,8000165a <wait+0xe6>
      if(np->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <wait+0xba>
        acquire(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	a4a080e7          	jalr	-1462(ra) # 80006088 <acquire>
        if(np->state == ZOMBIE){
    80001646:	4c9c                	lw	a5,24(s1)
    80001648:	f94781e3          	beq	a5,s4,800015ca <wait+0x56>
        release(&np->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	aee080e7          	jalr	-1298(ra) # 8000613c <release>
        havekids = 1;
    80001656:	8756                	mv	a4,s5
    80001658:	bfd9                	j	8000162e <wait+0xba>
    if(!havekids || p->killed){
    8000165a:	c701                	beqz	a4,80001662 <wait+0xee>
    8000165c:	02892783          	lw	a5,40(s2)
    80001660:	c79d                	beqz	a5,8000168e <wait+0x11a>
      release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	ad2080e7          	jalr	-1326(ra) # 8000613c <release>
      return -1;
    80001672:	59fd                	li	s3,-1
}
    80001674:	854e                	mv	a0,s3
    80001676:	60a6                	ld	ra,72(sp)
    80001678:	6406                	ld	s0,64(sp)
    8000167a:	74e2                	ld	s1,56(sp)
    8000167c:	7942                	ld	s2,48(sp)
    8000167e:	79a2                	ld	s3,40(sp)
    80001680:	7a02                	ld	s4,32(sp)
    80001682:	6ae2                	ld	s5,24(sp)
    80001684:	6b42                	ld	s6,16(sp)
    80001686:	6ba2                	ld	s7,8(sp)
    80001688:	6c02                	ld	s8,0(sp)
    8000168a:	6161                	addi	sp,sp,80
    8000168c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000168e:	85e2                	mv	a1,s8
    80001690:	854a                	mv	a0,s2
    80001692:	00000097          	auipc	ra,0x0
    80001696:	e7e080e7          	jalr	-386(ra) # 80001510 <sleep>
    havekids = 0;
    8000169a:	b715                	j	800015be <wait+0x4a>

000000008000169c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000169c:	7139                	addi	sp,sp,-64
    8000169e:	fc06                	sd	ra,56(sp)
    800016a0:	f822                	sd	s0,48(sp)
    800016a2:	f426                	sd	s1,40(sp)
    800016a4:	f04a                	sd	s2,32(sp)
    800016a6:	ec4e                	sd	s3,24(sp)
    800016a8:	e852                	sd	s4,16(sp)
    800016aa:	e456                	sd	s5,8(sp)
    800016ac:	0080                	addi	s0,sp,64
    800016ae:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	00008497          	auipc	s1,0x8
    800016b4:	dd048493          	addi	s1,s1,-560 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ba:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016bc:	0000d917          	auipc	s2,0xd
    800016c0:	7c490913          	addi	s2,s2,1988 # 8000ee80 <tickslock>
    800016c4:	a811                	j	800016d8 <wakeup+0x3c>
      }
      release(&p->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	a74080e7          	jalr	-1420(ra) # 8000613c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d0:	16848493          	addi	s1,s1,360
    800016d4:	03248663          	beq	s1,s2,80001700 <wakeup+0x64>
    if(p != myproc()){
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	76c080e7          	jalr	1900(ra) # 80000e44 <myproc>
    800016e0:	fea488e3          	beq	s1,a0,800016d0 <wakeup+0x34>
      acquire(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	9a2080e7          	jalr	-1630(ra) # 80006088 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016ee:	4c9c                	lw	a5,24(s1)
    800016f0:	fd379be3          	bne	a5,s3,800016c6 <wakeup+0x2a>
    800016f4:	709c                	ld	a5,32(s1)
    800016f6:	fd4798e3          	bne	a5,s4,800016c6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016fa:	0154ac23          	sw	s5,24(s1)
    800016fe:	b7e1                	j	800016c6 <wakeup+0x2a>
    }
  }
}
    80001700:	70e2                	ld	ra,56(sp)
    80001702:	7442                	ld	s0,48(sp)
    80001704:	74a2                	ld	s1,40(sp)
    80001706:	7902                	ld	s2,32(sp)
    80001708:	69e2                	ld	s3,24(sp)
    8000170a:	6a42                	ld	s4,16(sp)
    8000170c:	6aa2                	ld	s5,8(sp)
    8000170e:	6121                	addi	sp,sp,64
    80001710:	8082                	ret

0000000080001712 <reparent>:
{
    80001712:	7179                	addi	sp,sp,-48
    80001714:	f406                	sd	ra,40(sp)
    80001716:	f022                	sd	s0,32(sp)
    80001718:	ec26                	sd	s1,24(sp)
    8000171a:	e84a                	sd	s2,16(sp)
    8000171c:	e44e                	sd	s3,8(sp)
    8000171e:	e052                	sd	s4,0(sp)
    80001720:	1800                	addi	s0,sp,48
    80001722:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001724:	00008497          	auipc	s1,0x8
    80001728:	d5c48493          	addi	s1,s1,-676 # 80009480 <proc>
      pp->parent = initproc;
    8000172c:	00008a17          	auipc	s4,0x8
    80001730:	8e4a0a13          	addi	s4,s4,-1820 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001734:	0000d997          	auipc	s3,0xd
    80001738:	74c98993          	addi	s3,s3,1868 # 8000ee80 <tickslock>
    8000173c:	a029                	j	80001746 <reparent+0x34>
    8000173e:	16848493          	addi	s1,s1,360
    80001742:	01348d63          	beq	s1,s3,8000175c <reparent+0x4a>
    if(pp->parent == p){
    80001746:	7c9c                	ld	a5,56(s1)
    80001748:	ff279be3          	bne	a5,s2,8000173e <reparent+0x2c>
      pp->parent = initproc;
    8000174c:	000a3503          	ld	a0,0(s4)
    80001750:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001752:	00000097          	auipc	ra,0x0
    80001756:	f4a080e7          	jalr	-182(ra) # 8000169c <wakeup>
    8000175a:	b7d5                	j	8000173e <reparent+0x2c>
}
    8000175c:	70a2                	ld	ra,40(sp)
    8000175e:	7402                	ld	s0,32(sp)
    80001760:	64e2                	ld	s1,24(sp)
    80001762:	6942                	ld	s2,16(sp)
    80001764:	69a2                	ld	s3,8(sp)
    80001766:	6a02                	ld	s4,0(sp)
    80001768:	6145                	addi	sp,sp,48
    8000176a:	8082                	ret

000000008000176c <exit>:
{
    8000176c:	7179                	addi	sp,sp,-48
    8000176e:	f406                	sd	ra,40(sp)
    80001770:	f022                	sd	s0,32(sp)
    80001772:	ec26                	sd	s1,24(sp)
    80001774:	e84a                	sd	s2,16(sp)
    80001776:	e44e                	sd	s3,8(sp)
    80001778:	e052                	sd	s4,0(sp)
    8000177a:	1800                	addi	s0,sp,48
    8000177c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	6c6080e7          	jalr	1734(ra) # 80000e44 <myproc>
    80001786:	89aa                	mv	s3,a0
  if(p == initproc)
    80001788:	00008797          	auipc	a5,0x8
    8000178c:	8887b783          	ld	a5,-1912(a5) # 80009010 <initproc>
    80001790:	0d050493          	addi	s1,a0,208
    80001794:	15050913          	addi	s2,a0,336
    80001798:	02a79363          	bne	a5,a0,800017be <exit+0x52>
    panic("init exiting");
    8000179c:	00007517          	auipc	a0,0x7
    800017a0:	a4450513          	addi	a0,a0,-1468 # 800081e0 <etext+0x1e0>
    800017a4:	00004097          	auipc	ra,0x4
    800017a8:	3ac080e7          	jalr	940(ra) # 80005b50 <panic>
      fileclose(f);
    800017ac:	00002097          	auipc	ra,0x2
    800017b0:	1d6080e7          	jalr	470(ra) # 80003982 <fileclose>
      p->ofile[fd] = 0;
    800017b4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b8:	04a1                	addi	s1,s1,8
    800017ba:	01248563          	beq	s1,s2,800017c4 <exit+0x58>
    if(p->ofile[fd]){
    800017be:	6088                	ld	a0,0(s1)
    800017c0:	f575                	bnez	a0,800017ac <exit+0x40>
    800017c2:	bfdd                	j	800017b8 <exit+0x4c>
  begin_op();
    800017c4:	00002097          	auipc	ra,0x2
    800017c8:	cf6080e7          	jalr	-778(ra) # 800034ba <begin_op>
  iput(p->cwd);
    800017cc:	1509b503          	ld	a0,336(s3)
    800017d0:	00001097          	auipc	ra,0x1
    800017d4:	4c8080e7          	jalr	1224(ra) # 80002c98 <iput>
  end_op();
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	d60080e7          	jalr	-672(ra) # 80003538 <end_op>
  p->cwd = 0;
    800017e0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e4:	00008497          	auipc	s1,0x8
    800017e8:	88448493          	addi	s1,s1,-1916 # 80009068 <wait_lock>
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	89a080e7          	jalr	-1894(ra) # 80006088 <acquire>
  reparent(p);
    800017f6:	854e                	mv	a0,s3
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	f1a080e7          	jalr	-230(ra) # 80001712 <reparent>
  wakeup(p->parent);
    80001800:	0389b503          	ld	a0,56(s3)
    80001804:	00000097          	auipc	ra,0x0
    80001808:	e98080e7          	jalr	-360(ra) # 8000169c <wakeup>
  acquire(&p->lock);
    8000180c:	854e                	mv	a0,s3
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	87a080e7          	jalr	-1926(ra) # 80006088 <acquire>
  p->xstate = status;
    80001816:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181a:	4795                	li	a5,5
    8000181c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001820:	8526                	mv	a0,s1
    80001822:	00005097          	auipc	ra,0x5
    80001826:	91a080e7          	jalr	-1766(ra) # 8000613c <release>
  sched();
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	bd4080e7          	jalr	-1068(ra) # 800013fe <sched>
  panic("zombie exit");
    80001832:	00007517          	auipc	a0,0x7
    80001836:	9be50513          	addi	a0,a0,-1602 # 800081f0 <etext+0x1f0>
    8000183a:	00004097          	auipc	ra,0x4
    8000183e:	316080e7          	jalr	790(ra) # 80005b50 <panic>

0000000080001842 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001842:	7179                	addi	sp,sp,-48
    80001844:	f406                	sd	ra,40(sp)
    80001846:	f022                	sd	s0,32(sp)
    80001848:	ec26                	sd	s1,24(sp)
    8000184a:	e84a                	sd	s2,16(sp)
    8000184c:	e44e                	sd	s3,8(sp)
    8000184e:	1800                	addi	s0,sp,48
    80001850:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001852:	00008497          	auipc	s1,0x8
    80001856:	c2e48493          	addi	s1,s1,-978 # 80009480 <proc>
    8000185a:	0000d997          	auipc	s3,0xd
    8000185e:	62698993          	addi	s3,s3,1574 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	824080e7          	jalr	-2012(ra) # 80006088 <acquire>
    if(p->pid == pid){
    8000186c:	589c                	lw	a5,48(s1)
    8000186e:	01278d63          	beq	a5,s2,80001888 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	8c8080e7          	jalr	-1848(ra) # 8000613c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000187c:	16848493          	addi	s1,s1,360
    80001880:	ff3491e3          	bne	s1,s3,80001862 <kill+0x20>
  }
  return -1;
    80001884:	557d                	li	a0,-1
    80001886:	a829                	j	800018a0 <kill+0x5e>
      p->killed = 1;
    80001888:	4785                	li	a5,1
    8000188a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188c:	4c98                	lw	a4,24(s1)
    8000188e:	4789                	li	a5,2
    80001890:	00f70f63          	beq	a4,a5,800018ae <kill+0x6c>
      release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	8a6080e7          	jalr	-1882(ra) # 8000613c <release>
      return 0;
    8000189e:	4501                	li	a0,0
}
    800018a0:	70a2                	ld	ra,40(sp)
    800018a2:	7402                	ld	s0,32(sp)
    800018a4:	64e2                	ld	s1,24(sp)
    800018a6:	6942                	ld	s2,16(sp)
    800018a8:	69a2                	ld	s3,8(sp)
    800018aa:	6145                	addi	sp,sp,48
    800018ac:	8082                	ret
        p->state = RUNNABLE;
    800018ae:	478d                	li	a5,3
    800018b0:	cc9c                	sw	a5,24(s1)
    800018b2:	b7cd                	j	80001894 <kill+0x52>

00000000800018b4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b4:	7179                	addi	sp,sp,-48
    800018b6:	f406                	sd	ra,40(sp)
    800018b8:	f022                	sd	s0,32(sp)
    800018ba:	ec26                	sd	s1,24(sp)
    800018bc:	e84a                	sd	s2,16(sp)
    800018be:	e44e                	sd	s3,8(sp)
    800018c0:	e052                	sd	s4,0(sp)
    800018c2:	1800                	addi	s0,sp,48
    800018c4:	84aa                	mv	s1,a0
    800018c6:	892e                	mv	s2,a1
    800018c8:	89b2                	mv	s3,a2
    800018ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	578080e7          	jalr	1400(ra) # 80000e44 <myproc>
  if(user_dst){
    800018d4:	c08d                	beqz	s1,800018f6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d6:	86d2                	mv	a3,s4
    800018d8:	864e                	mv	a2,s3
    800018da:	85ca                	mv	a1,s2
    800018dc:	6928                	ld	a0,80(a0)
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	22a080e7          	jalr	554(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6a02                	ld	s4,0(sp)
    800018f2:	6145                	addi	sp,sp,48
    800018f4:	8082                	ret
    memmove((char *)dst, src, len);
    800018f6:	000a061b          	sext.w	a2,s4
    800018fa:	85ce                	mv	a1,s3
    800018fc:	854a                	mv	a0,s2
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	8d8080e7          	jalr	-1832(ra) # 800001d6 <memmove>
    return 0;
    80001906:	8526                	mv	a0,s1
    80001908:	bff9                	j	800018e6 <either_copyout+0x32>

000000008000190a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190a:	7179                	addi	sp,sp,-48
    8000190c:	f406                	sd	ra,40(sp)
    8000190e:	f022                	sd	s0,32(sp)
    80001910:	ec26                	sd	s1,24(sp)
    80001912:	e84a                	sd	s2,16(sp)
    80001914:	e44e                	sd	s3,8(sp)
    80001916:	e052                	sd	s4,0(sp)
    80001918:	1800                	addi	s0,sp,48
    8000191a:	892a                	mv	s2,a0
    8000191c:	84ae                	mv	s1,a1
    8000191e:	89b2                	mv	s3,a2
    80001920:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	522080e7          	jalr	1314(ra) # 80000e44 <myproc>
  if(user_src){
    8000192a:	c08d                	beqz	s1,8000194c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000192c:	86d2                	mv	a3,s4
    8000192e:	864e                	mv	a2,s3
    80001930:	85ca                	mv	a1,s2
    80001932:	6928                	ld	a0,80(a0)
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	260080e7          	jalr	608(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000193c:	70a2                	ld	ra,40(sp)
    8000193e:	7402                	ld	s0,32(sp)
    80001940:	64e2                	ld	s1,24(sp)
    80001942:	6942                	ld	s2,16(sp)
    80001944:	69a2                	ld	s3,8(sp)
    80001946:	6a02                	ld	s4,0(sp)
    80001948:	6145                	addi	sp,sp,48
    8000194a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000194c:	000a061b          	sext.w	a2,s4
    80001950:	85ce                	mv	a1,s3
    80001952:	854a                	mv	a0,s2
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	882080e7          	jalr	-1918(ra) # 800001d6 <memmove>
    return 0;
    8000195c:	8526                	mv	a0,s1
    8000195e:	bff9                	j	8000193c <either_copyin+0x32>

0000000080001960 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001960:	715d                	addi	sp,sp,-80
    80001962:	e486                	sd	ra,72(sp)
    80001964:	e0a2                	sd	s0,64(sp)
    80001966:	fc26                	sd	s1,56(sp)
    80001968:	f84a                	sd	s2,48(sp)
    8000196a:	f44e                	sd	s3,40(sp)
    8000196c:	f052                	sd	s4,32(sp)
    8000196e:	ec56                	sd	s5,24(sp)
    80001970:	e85a                	sd	s6,16(sp)
    80001972:	e45e                	sd	s7,8(sp)
    80001974:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001976:	00006517          	auipc	a0,0x6
    8000197a:	6d250513          	addi	a0,a0,1746 # 80008048 <etext+0x48>
    8000197e:	00004097          	auipc	ra,0x4
    80001982:	21c080e7          	jalr	540(ra) # 80005b9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	00008497          	auipc	s1,0x8
    8000198a:	c5248493          	addi	s1,s1,-942 # 800095d8 <proc+0x158>
    8000198e:	0000d917          	auipc	s2,0xd
    80001992:	64a90913          	addi	s2,s2,1610 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001996:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001998:	00007997          	auipc	s3,0x7
    8000199c:	86898993          	addi	s3,s3,-1944 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a0:	00007a97          	auipc	s5,0x7
    800019a4:	868a8a93          	addi	s5,s5,-1944 # 80008208 <etext+0x208>
    printf("\n");
    800019a8:	00006a17          	auipc	s4,0x6
    800019ac:	6a0a0a13          	addi	s4,s4,1696 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b0:	00007b97          	auipc	s7,0x7
    800019b4:	890b8b93          	addi	s7,s7,-1904 # 80008240 <states.0>
    800019b8:	a00d                	j	800019da <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ba:	ed86a583          	lw	a1,-296(a3)
    800019be:	8556                	mv	a0,s5
    800019c0:	00004097          	auipc	ra,0x4
    800019c4:	1da080e7          	jalr	474(ra) # 80005b9a <printf>
    printf("\n");
    800019c8:	8552                	mv	a0,s4
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	1d0080e7          	jalr	464(ra) # 80005b9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	16848493          	addi	s1,s1,360
    800019d6:	03248263          	beq	s1,s2,800019fa <procdump+0x9a>
    if(p->state == UNUSED)
    800019da:	86a6                	mv	a3,s1
    800019dc:	ec04a783          	lw	a5,-320(s1)
    800019e0:	dbed                	beqz	a5,800019d2 <procdump+0x72>
      state = "???";
    800019e2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	fcfb6be3          	bltu	s6,a5,800019ba <procdump+0x5a>
    800019e8:	02079713          	slli	a4,a5,0x20
    800019ec:	01d75793          	srli	a5,a4,0x1d
    800019f0:	97de                	add	a5,a5,s7
    800019f2:	6390                	ld	a2,0(a5)
    800019f4:	f279                	bnez	a2,800019ba <procdump+0x5a>
      state = "???";
    800019f6:	864e                	mv	a2,s3
    800019f8:	b7c9                	j	800019ba <procdump+0x5a>
  }
}
    800019fa:	60a6                	ld	ra,72(sp)
    800019fc:	6406                	ld	s0,64(sp)
    800019fe:	74e2                	ld	s1,56(sp)
    80001a00:	7942                	ld	s2,48(sp)
    80001a02:	79a2                	ld	s3,40(sp)
    80001a04:	7a02                	ld	s4,32(sp)
    80001a06:	6ae2                	ld	s5,24(sp)
    80001a08:	6b42                	ld	s6,16(sp)
    80001a0a:	6ba2                	ld	s7,8(sp)
    80001a0c:	6161                	addi	sp,sp,80
    80001a0e:	8082                	ret

0000000080001a10 <swtch>:
    80001a10:	00153023          	sd	ra,0(a0)
    80001a14:	00253423          	sd	sp,8(a0)
    80001a18:	e900                	sd	s0,16(a0)
    80001a1a:	ed04                	sd	s1,24(a0)
    80001a1c:	03253023          	sd	s2,32(a0)
    80001a20:	03353423          	sd	s3,40(a0)
    80001a24:	03453823          	sd	s4,48(a0)
    80001a28:	03553c23          	sd	s5,56(a0)
    80001a2c:	05653023          	sd	s6,64(a0)
    80001a30:	05753423          	sd	s7,72(a0)
    80001a34:	05853823          	sd	s8,80(a0)
    80001a38:	05953c23          	sd	s9,88(a0)
    80001a3c:	07a53023          	sd	s10,96(a0)
    80001a40:	07b53423          	sd	s11,104(a0)
    80001a44:	0005b083          	ld	ra,0(a1)
    80001a48:	0085b103          	ld	sp,8(a1)
    80001a4c:	6980                	ld	s0,16(a1)
    80001a4e:	6d84                	ld	s1,24(a1)
    80001a50:	0205b903          	ld	s2,32(a1)
    80001a54:	0285b983          	ld	s3,40(a1)
    80001a58:	0305ba03          	ld	s4,48(a1)
    80001a5c:	0385ba83          	ld	s5,56(a1)
    80001a60:	0405bb03          	ld	s6,64(a1)
    80001a64:	0485bb83          	ld	s7,72(a1)
    80001a68:	0505bc03          	ld	s8,80(a1)
    80001a6c:	0585bc83          	ld	s9,88(a1)
    80001a70:	0605bd03          	ld	s10,96(a1)
    80001a74:	0685bd83          	ld	s11,104(a1)
    80001a78:	8082                	ret

0000000080001a7a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a7a:	1141                	addi	sp,sp,-16
    80001a7c:	e406                	sd	ra,8(sp)
    80001a7e:	e022                	sd	s0,0(sp)
    80001a80:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a82:	00006597          	auipc	a1,0x6
    80001a86:	7ee58593          	addi	a1,a1,2030 # 80008270 <states.0+0x30>
    80001a8a:	0000d517          	auipc	a0,0xd
    80001a8e:	3f650513          	addi	a0,a0,1014 # 8000ee80 <tickslock>
    80001a92:	00004097          	auipc	ra,0x4
    80001a96:	566080e7          	jalr	1382(ra) # 80005ff8 <initlock>
}
    80001a9a:	60a2                	ld	ra,8(sp)
    80001a9c:	6402                	ld	s0,0(sp)
    80001a9e:	0141                	addi	sp,sp,16
    80001aa0:	8082                	ret

0000000080001aa2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e422                	sd	s0,8(sp)
    80001aa6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa8:	00003797          	auipc	a5,0x3
    80001aac:	50878793          	addi	a5,a5,1288 # 80004fb0 <kernelvec>
    80001ab0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab4:	6422                	ld	s0,8(sp)
    80001ab6:	0141                	addi	sp,sp,16
    80001ab8:	8082                	ret

0000000080001aba <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aba:	1141                	addi	sp,sp,-16
    80001abc:	e406                	sd	ra,8(sp)
    80001abe:	e022                	sd	s0,0(sp)
    80001ac0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	382080e7          	jalr	898(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ace:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad4:	00005697          	auipc	a3,0x5
    80001ad8:	52c68693          	addi	a3,a3,1324 # 80007000 <_trampoline>
    80001adc:	00005717          	auipc	a4,0x5
    80001ae0:	52470713          	addi	a4,a4,1316 # 80007000 <_trampoline>
    80001ae4:	8f15                	sub	a4,a4,a3
    80001ae6:	040007b7          	lui	a5,0x4000
    80001aea:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001aec:	07b2                	slli	a5,a5,0xc
    80001aee:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af6:	18002673          	csrr	a2,satp
    80001afa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001afc:	6d30                	ld	a2,88(a0)
    80001afe:	6138                	ld	a4,64(a0)
    80001b00:	6585                	lui	a1,0x1
    80001b02:	972e                	add	a4,a4,a1
    80001b04:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b06:	6d38                	ld	a4,88(a0)
    80001b08:	00000617          	auipc	a2,0x0
    80001b0c:	13860613          	addi	a2,a2,312 # 80001c40 <usertrap>
    80001b10:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b12:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b14:	8612                	mv	a2,tp
    80001b16:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b20:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b24:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b28:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b2a:	6f18                	ld	a4,24(a4)
    80001b2c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b30:	692c                	ld	a1,80(a0)
    80001b32:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b34:	00005717          	auipc	a4,0x5
    80001b38:	55c70713          	addi	a4,a4,1372 # 80007090 <userret>
    80001b3c:	8f15                	sub	a4,a4,a3
    80001b3e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b40:	577d                	li	a4,-1
    80001b42:	177e                	slli	a4,a4,0x3f
    80001b44:	8dd9                	or	a1,a1,a4
    80001b46:	02000537          	lui	a0,0x2000
    80001b4a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b4c:	0536                	slli	a0,a0,0xd
    80001b4e:	9782                	jalr	a5
}
    80001b50:	60a2                	ld	ra,8(sp)
    80001b52:	6402                	ld	s0,0(sp)
    80001b54:	0141                	addi	sp,sp,16
    80001b56:	8082                	ret

0000000080001b58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b58:	1101                	addi	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b62:	0000d497          	auipc	s1,0xd
    80001b66:	31e48493          	addi	s1,s1,798 # 8000ee80 <tickslock>
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00004097          	auipc	ra,0x4
    80001b70:	51c080e7          	jalr	1308(ra) # 80006088 <acquire>
  ticks++;
    80001b74:	00007517          	auipc	a0,0x7
    80001b78:	4a450513          	addi	a0,a0,1188 # 80009018 <ticks>
    80001b7c:	411c                	lw	a5,0(a0)
    80001b7e:	2785                	addiw	a5,a5,1
    80001b80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b82:	00000097          	auipc	ra,0x0
    80001b86:	b1a080e7          	jalr	-1254(ra) # 8000169c <wakeup>
  release(&tickslock);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	00004097          	auipc	ra,0x4
    80001b90:	5b0080e7          	jalr	1456(ra) # 8000613c <release>
}
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6105                	addi	sp,sp,32
    80001b9c:	8082                	ret

0000000080001b9e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bac:	00074d63          	bltz	a4,80001bc6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb0:	57fd                	li	a5,-1
    80001bb2:	17fe                	slli	a5,a5,0x3f
    80001bb4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb8:	06f70363          	beq	a4,a5,80001c1e <devintr+0x80>
  }
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
     (scause & 0xff) == 9){
    80001bc6:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bca:	46a5                	li	a3,9
    80001bcc:	fed792e3          	bne	a5,a3,80001bb0 <devintr+0x12>
    int irq = plic_claim();
    80001bd0:	00003097          	auipc	ra,0x3
    80001bd4:	4e8080e7          	jalr	1256(ra) # 800050b8 <plic_claim>
    80001bd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bda:	47a9                	li	a5,10
    80001bdc:	02f50763          	beq	a0,a5,80001c0a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be0:	4785                	li	a5,1
    80001be2:	02f50963          	beq	a0,a5,80001c14 <devintr+0x76>
    return 1;
    80001be6:	4505                	li	a0,1
    } else if(irq){
    80001be8:	d8f1                	beqz	s1,80001bbc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bea:	85a6                	mv	a1,s1
    80001bec:	00006517          	auipc	a0,0x6
    80001bf0:	68c50513          	addi	a0,a0,1676 # 80008278 <states.0+0x38>
    80001bf4:	00004097          	auipc	ra,0x4
    80001bf8:	fa6080e7          	jalr	-90(ra) # 80005b9a <printf>
      plic_complete(irq);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00003097          	auipc	ra,0x3
    80001c02:	4de080e7          	jalr	1246(ra) # 800050dc <plic_complete>
    return 1;
    80001c06:	4505                	li	a0,1
    80001c08:	bf55                	j	80001bbc <devintr+0x1e>
      uartintr();
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	39e080e7          	jalr	926(ra) # 80005fa8 <uartintr>
    80001c12:	b7ed                	j	80001bfc <devintr+0x5e>
      virtio_disk_intr();
    80001c14:	00004097          	auipc	ra,0x4
    80001c18:	954080e7          	jalr	-1708(ra) # 80005568 <virtio_disk_intr>
    80001c1c:	b7c5                	j	80001bfc <devintr+0x5e>
    if(cpuid() == 0){
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	1fa080e7          	jalr	506(ra) # 80000e18 <cpuid>
    80001c26:	c901                	beqz	a0,80001c36 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c28:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c2e:	14479073          	csrw	sip,a5
    return 2;
    80001c32:	4509                	li	a0,2
    80001c34:	b761                	j	80001bbc <devintr+0x1e>
      clockintr();
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	f22080e7          	jalr	-222(ra) # 80001b58 <clockintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x8a>

0000000080001c40 <usertrap>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	e04a                	sd	s2,0(sp)
    80001c4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c50:	1007f793          	andi	a5,a5,256
    80001c54:	e3ad                	bnez	a5,80001cb6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c56:	00003797          	auipc	a5,0x3
    80001c5a:	35a78793          	addi	a5,a5,858 # 80004fb0 <kernelvec>
    80001c5e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	1e2080e7          	jalr	482(ra) # 80000e44 <myproc>
    80001c6a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6e:	14102773          	csrr	a4,sepc
    80001c72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c78:	47a1                	li	a5,8
    80001c7a:	04f71c63          	bne	a4,a5,80001cd2 <usertrap+0x92>
    if(p->killed)
    80001c7e:	551c                	lw	a5,40(a0)
    80001c80:	e3b9                	bnez	a5,80001cc6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c82:	6cb8                	ld	a4,88(s1)
    80001c84:	6f1c                	ld	a5,24(a4)
    80001c86:	0791                	addi	a5,a5,4
    80001c88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c92:	10079073          	csrw	sstatus,a5
    syscall();
    80001c96:	00000097          	auipc	ra,0x0
    80001c9a:	2e0080e7          	jalr	736(ra) # 80001f76 <syscall>
  if(p->killed)
    80001c9e:	549c                	lw	a5,40(s1)
    80001ca0:	ebc1                	bnez	a5,80001d30 <usertrap+0xf0>
  usertrapret();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	e18080e7          	jalr	-488(ra) # 80001aba <usertrapret>
}
    80001caa:	60e2                	ld	ra,24(sp)
    80001cac:	6442                	ld	s0,16(sp)
    80001cae:	64a2                	ld	s1,8(sp)
    80001cb0:	6902                	ld	s2,0(sp)
    80001cb2:	6105                	addi	sp,sp,32
    80001cb4:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb6:	00006517          	auipc	a0,0x6
    80001cba:	5e250513          	addi	a0,a0,1506 # 80008298 <states.0+0x58>
    80001cbe:	00004097          	auipc	ra,0x4
    80001cc2:	e92080e7          	jalr	-366(ra) # 80005b50 <panic>
      exit(-1);
    80001cc6:	557d                	li	a0,-1
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	aa4080e7          	jalr	-1372(ra) # 8000176c <exit>
    80001cd0:	bf4d                	j	80001c82 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	ecc080e7          	jalr	-308(ra) # 80001b9e <devintr>
    80001cda:	892a                	mv	s2,a0
    80001cdc:	c501                	beqz	a0,80001ce4 <usertrap+0xa4>
  if(p->killed)
    80001cde:	549c                	lw	a5,40(s1)
    80001ce0:	c3a1                	beqz	a5,80001d20 <usertrap+0xe0>
    80001ce2:	a815                	j	80001d16 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce8:	5890                	lw	a2,48(s1)
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5ce50513          	addi	a0,a0,1486 # 800082b8 <states.0+0x78>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	ea8080e7          	jalr	-344(ra) # 80005b9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cfa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cfe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	5e650513          	addi	a0,a0,1510 # 800082e8 <states.0+0xa8>
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	e90080e7          	jalr	-368(ra) # 80005b9a <printf>
    p->killed = 1;
    80001d12:	4785                	li	a5,1
    80001d14:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d16:	557d                	li	a0,-1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	a54080e7          	jalr	-1452(ra) # 8000176c <exit>
  if(which_dev == 2)
    80001d20:	4789                	li	a5,2
    80001d22:	f8f910e3          	bne	s2,a5,80001ca2 <usertrap+0x62>
    yield();
    80001d26:	fffff097          	auipc	ra,0xfffff
    80001d2a:	7ae080e7          	jalr	1966(ra) # 800014d4 <yield>
    80001d2e:	bf95                	j	80001ca2 <usertrap+0x62>
  int which_dev = 0;
    80001d30:	4901                	li	s2,0
    80001d32:	b7d5                	j	80001d16 <usertrap+0xd6>

0000000080001d34 <kerneltrap>:
{
    80001d34:	7179                	addi	sp,sp,-48
    80001d36:	f406                	sd	ra,40(sp)
    80001d38:	f022                	sd	s0,32(sp)
    80001d3a:	ec26                	sd	s1,24(sp)
    80001d3c:	e84a                	sd	s2,16(sp)
    80001d3e:	e44e                	sd	s3,8(sp)
    80001d40:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d42:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d4a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d4e:	1004f793          	andi	a5,s1,256
    80001d52:	cb85                	beqz	a5,80001d82 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d54:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d58:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d5a:	ef85                	bnez	a5,80001d92 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	e42080e7          	jalr	-446(ra) # 80001b9e <devintr>
    80001d64:	cd1d                	beqz	a0,80001da2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d66:	4789                	li	a5,2
    80001d68:	06f50a63          	beq	a0,a5,80001ddc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d6c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d70:	10049073          	csrw	sstatus,s1
}
    80001d74:	70a2                	ld	ra,40(sp)
    80001d76:	7402                	ld	s0,32(sp)
    80001d78:	64e2                	ld	s1,24(sp)
    80001d7a:	6942                	ld	s2,16(sp)
    80001d7c:	69a2                	ld	s3,8(sp)
    80001d7e:	6145                	addi	sp,sp,48
    80001d80:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	58650513          	addi	a0,a0,1414 # 80008308 <states.0+0xc8>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	dc6080e7          	jalr	-570(ra) # 80005b50 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d92:	00006517          	auipc	a0,0x6
    80001d96:	59e50513          	addi	a0,a0,1438 # 80008330 <states.0+0xf0>
    80001d9a:	00004097          	auipc	ra,0x4
    80001d9e:	db6080e7          	jalr	-586(ra) # 80005b50 <panic>
    printf("scause %p\n", scause);
    80001da2:	85ce                	mv	a1,s3
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	5ac50513          	addi	a0,a0,1452 # 80008350 <states.0+0x110>
    80001dac:	00004097          	auipc	ra,0x4
    80001db0:	dee080e7          	jalr	-530(ra) # 80005b9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	5a450513          	addi	a0,a0,1444 # 80008360 <states.0+0x120>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	dd6080e7          	jalr	-554(ra) # 80005b9a <printf>
    panic("kerneltrap");
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	5ac50513          	addi	a0,a0,1452 # 80008378 <states.0+0x138>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	d7c080e7          	jalr	-644(ra) # 80005b50 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	068080e7          	jalr	104(ra) # 80000e44 <myproc>
    80001de4:	d541                	beqz	a0,80001d6c <kerneltrap+0x38>
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	05e080e7          	jalr	94(ra) # 80000e44 <myproc>
    80001dee:	4d18                	lw	a4,24(a0)
    80001df0:	4791                	li	a5,4
    80001df2:	f6f71de3          	bne	a4,a5,80001d6c <kerneltrap+0x38>
    yield();
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	6de080e7          	jalr	1758(ra) # 800014d4 <yield>
    80001dfe:	b7bd                	j	80001d6c <kerneltrap+0x38>

0000000080001e00 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e00:	1101                	addi	sp,sp,-32
    80001e02:	ec06                	sd	ra,24(sp)
    80001e04:	e822                	sd	s0,16(sp)
    80001e06:	e426                	sd	s1,8(sp)
    80001e08:	1000                	addi	s0,sp,32
    80001e0a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	038080e7          	jalr	56(ra) # 80000e44 <myproc>
  switch (n) {
    80001e14:	4795                	li	a5,5
    80001e16:	0497e163          	bltu	a5,s1,80001e58 <argraw+0x58>
    80001e1a:	048a                	slli	s1,s1,0x2
    80001e1c:	00006717          	auipc	a4,0x6
    80001e20:	65c70713          	addi	a4,a4,1628 # 80008478 <states.0+0x238>
    80001e24:	94ba                	add	s1,s1,a4
    80001e26:	409c                	lw	a5,0(s1)
    80001e28:	97ba                	add	a5,a5,a4
    80001e2a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e30:	60e2                	ld	ra,24(sp)
    80001e32:	6442                	ld	s0,16(sp)
    80001e34:	64a2                	ld	s1,8(sp)
    80001e36:	6105                	addi	sp,sp,32
    80001e38:	8082                	ret
    return p->trapframe->a1;
    80001e3a:	6d3c                	ld	a5,88(a0)
    80001e3c:	7fa8                	ld	a0,120(a5)
    80001e3e:	bfcd                	j	80001e30 <argraw+0x30>
    return p->trapframe->a2;
    80001e40:	6d3c                	ld	a5,88(a0)
    80001e42:	63c8                	ld	a0,128(a5)
    80001e44:	b7f5                	j	80001e30 <argraw+0x30>
    return p->trapframe->a3;
    80001e46:	6d3c                	ld	a5,88(a0)
    80001e48:	67c8                	ld	a0,136(a5)
    80001e4a:	b7dd                	j	80001e30 <argraw+0x30>
    return p->trapframe->a4;
    80001e4c:	6d3c                	ld	a5,88(a0)
    80001e4e:	6bc8                	ld	a0,144(a5)
    80001e50:	b7c5                	j	80001e30 <argraw+0x30>
    return p->trapframe->a5;
    80001e52:	6d3c                	ld	a5,88(a0)
    80001e54:	6fc8                	ld	a0,152(a5)
    80001e56:	bfe9                	j	80001e30 <argraw+0x30>
  panic("argraw");
    80001e58:	00006517          	auipc	a0,0x6
    80001e5c:	53050513          	addi	a0,a0,1328 # 80008388 <states.0+0x148>
    80001e60:	00004097          	auipc	ra,0x4
    80001e64:	cf0080e7          	jalr	-784(ra) # 80005b50 <panic>

0000000080001e68 <fetchaddr>:
{
    80001e68:	1101                	addi	sp,sp,-32
    80001e6a:	ec06                	sd	ra,24(sp)
    80001e6c:	e822                	sd	s0,16(sp)
    80001e6e:	e426                	sd	s1,8(sp)
    80001e70:	e04a                	sd	s2,0(sp)
    80001e72:	1000                	addi	s0,sp,32
    80001e74:	84aa                	mv	s1,a0
    80001e76:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	fcc080e7          	jalr	-52(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e80:	653c                	ld	a5,72(a0)
    80001e82:	02f4f863          	bgeu	s1,a5,80001eb2 <fetchaddr+0x4a>
    80001e86:	00848713          	addi	a4,s1,8
    80001e8a:	02e7e663          	bltu	a5,a4,80001eb6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e8e:	46a1                	li	a3,8
    80001e90:	8626                	mv	a2,s1
    80001e92:	85ca                	mv	a1,s2
    80001e94:	6928                	ld	a0,80(a0)
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	cfe080e7          	jalr	-770(ra) # 80000b94 <copyin>
    80001e9e:	00a03533          	snez	a0,a0
    80001ea2:	40a00533          	neg	a0,a0
}
    80001ea6:	60e2                	ld	ra,24(sp)
    80001ea8:	6442                	ld	s0,16(sp)
    80001eaa:	64a2                	ld	s1,8(sp)
    80001eac:	6902                	ld	s2,0(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret
    return -1;
    80001eb2:	557d                	li	a0,-1
    80001eb4:	bfcd                	j	80001ea6 <fetchaddr+0x3e>
    80001eb6:	557d                	li	a0,-1
    80001eb8:	b7fd                	j	80001ea6 <fetchaddr+0x3e>

0000000080001eba <fetchstr>:
{
    80001eba:	7179                	addi	sp,sp,-48
    80001ebc:	f406                	sd	ra,40(sp)
    80001ebe:	f022                	sd	s0,32(sp)
    80001ec0:	ec26                	sd	s1,24(sp)
    80001ec2:	e84a                	sd	s2,16(sp)
    80001ec4:	e44e                	sd	s3,8(sp)
    80001ec6:	1800                	addi	s0,sp,48
    80001ec8:	892a                	mv	s2,a0
    80001eca:	84ae                	mv	s1,a1
    80001ecc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	f76080e7          	jalr	-138(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ed6:	86ce                	mv	a3,s3
    80001ed8:	864a                	mv	a2,s2
    80001eda:	85a6                	mv	a1,s1
    80001edc:	6928                	ld	a0,80(a0)
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	d44080e7          	jalr	-700(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ee6:	00054763          	bltz	a0,80001ef4 <fetchstr+0x3a>
  return strlen(buf);
    80001eea:	8526                	mv	a0,s1
    80001eec:	ffffe097          	auipc	ra,0xffffe
    80001ef0:	40a080e7          	jalr	1034(ra) # 800002f6 <strlen>
}
    80001ef4:	70a2                	ld	ra,40(sp)
    80001ef6:	7402                	ld	s0,32(sp)
    80001ef8:	64e2                	ld	s1,24(sp)
    80001efa:	6942                	ld	s2,16(sp)
    80001efc:	69a2                	ld	s3,8(sp)
    80001efe:	6145                	addi	sp,sp,48
    80001f00:	8082                	ret

0000000080001f02 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f02:	1101                	addi	sp,sp,-32
    80001f04:	ec06                	sd	ra,24(sp)
    80001f06:	e822                	sd	s0,16(sp)
    80001f08:	e426                	sd	s1,8(sp)
    80001f0a:	1000                	addi	s0,sp,32
    80001f0c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f0e:	00000097          	auipc	ra,0x0
    80001f12:	ef2080e7          	jalr	-270(ra) # 80001e00 <argraw>
    80001f16:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f18:	4501                	li	a0,0
    80001f1a:	60e2                	ld	ra,24(sp)
    80001f1c:	6442                	ld	s0,16(sp)
    80001f1e:	64a2                	ld	s1,8(sp)
    80001f20:	6105                	addi	sp,sp,32
    80001f22:	8082                	ret

0000000080001f24 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	1000                	addi	s0,sp,32
    80001f2e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f30:	00000097          	auipc	ra,0x0
    80001f34:	ed0080e7          	jalr	-304(ra) # 80001e00 <argraw>
    80001f38:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f3a:	4501                	li	a0,0
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret

0000000080001f46 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f46:	1101                	addi	sp,sp,-32
    80001f48:	ec06                	sd	ra,24(sp)
    80001f4a:	e822                	sd	s0,16(sp)
    80001f4c:	e426                	sd	s1,8(sp)
    80001f4e:	e04a                	sd	s2,0(sp)
    80001f50:	1000                	addi	s0,sp,32
    80001f52:	84ae                	mv	s1,a1
    80001f54:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	eaa080e7          	jalr	-342(ra) # 80001e00 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f5e:	864a                	mv	a2,s2
    80001f60:	85a6                	mv	a1,s1
    80001f62:	00000097          	auipc	ra,0x0
    80001f66:	f58080e7          	jalr	-168(ra) # 80001eba <fetchstr>
}
    80001f6a:	60e2                	ld	ra,24(sp)
    80001f6c:	6442                	ld	s0,16(sp)
    80001f6e:	64a2                	ld	s1,8(sp)
    80001f70:	6902                	ld	s2,0(sp)
    80001f72:	6105                	addi	sp,sp,32
    80001f74:	8082                	ret

0000000080001f76 <syscall>:
[SYS_trace]   sys_trace,
};
char* syscall_name[24] = {" ","fork","exit","wait","pipe","read","kill","exec","fstat","chdir","dup","getpid","sbrk","sleep","uptime","open","write","mknod","unlink","link","mkdir","close","trace"};
void
syscall(void)
{
    80001f76:	7179                	addi	sp,sp,-48
    80001f78:	f406                	sd	ra,40(sp)
    80001f7a:	f022                	sd	s0,32(sp)
    80001f7c:	ec26                	sd	s1,24(sp)
    80001f7e:	e84a                	sd	s2,16(sp)
    80001f80:	e44e                	sd	s3,8(sp)
    80001f82:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	ec0080e7          	jalr	-320(ra) # 80000e44 <myproc>
    80001f8c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f8e:	05853903          	ld	s2,88(a0)
    80001f92:	0a893783          	ld	a5,168(s2)
    80001f96:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f9a:	37fd                	addiw	a5,a5,-1
    80001f9c:	4755                	li	a4,21
    80001f9e:	04f76663          	bltu	a4,a5,80001fea <syscall+0x74>
    80001fa2:	00399713          	slli	a4,s3,0x3
    80001fa6:	00006797          	auipc	a5,0x6
    80001faa:	4ea78793          	addi	a5,a5,1258 # 80008490 <syscalls>
    80001fae:	97ba                	add	a5,a5,a4
    80001fb0:	639c                	ld	a5,0(a5)
    80001fb2:	cf85                	beqz	a5,80001fea <syscall+0x74>
    p->trapframe->a0 = syscalls[num]();
    80001fb4:	9782                	jalr	a5
    80001fb6:	06a93823          	sd	a0,112(s2)
    if(p->mask & (1<<num) ){
    80001fba:	58dc                	lw	a5,52(s1)
    80001fbc:	4137d7bb          	sraw	a5,a5,s3
    80001fc0:	8b85                	andi	a5,a5,1
    80001fc2:	c3b9                	beqz	a5,80002008 <syscall+0x92>
      printf("%d: syscall %s -> %d\n",p->pid,syscall_name[num],p->trapframe->a0);
    80001fc4:	6cb8                	ld	a4,88(s1)
    80001fc6:	098e                	slli	s3,s3,0x3
    80001fc8:	00007797          	auipc	a5,0x7
    80001fcc:	96078793          	addi	a5,a5,-1696 # 80008928 <syscall_name>
    80001fd0:	97ce                	add	a5,a5,s3
    80001fd2:	7b34                	ld	a3,112(a4)
    80001fd4:	6390                	ld	a2,0(a5)
    80001fd6:	588c                	lw	a1,48(s1)
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	3b850513          	addi	a0,a0,952 # 80008390 <states.0+0x150>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	bba080e7          	jalr	-1094(ra) # 80005b9a <printf>
    80001fe8:	a005                	j	80002008 <syscall+0x92>
      //printf("%d %d\n",p->mask,num);
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fea:	86ce                	mv	a3,s3
    80001fec:	15848613          	addi	a2,s1,344
    80001ff0:	588c                	lw	a1,48(s1)
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	3b650513          	addi	a0,a0,950 # 800083a8 <states.0+0x168>
    80001ffa:	00004097          	auipc	ra,0x4
    80001ffe:	ba0080e7          	jalr	-1120(ra) # 80005b9a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002002:	6cbc                	ld	a5,88(s1)
    80002004:	577d                	li	a4,-1
    80002006:	fbb8                	sd	a4,112(a5)
  }
}
    80002008:	70a2                	ld	ra,40(sp)
    8000200a:	7402                	ld	s0,32(sp)
    8000200c:	64e2                	ld	s1,24(sp)
    8000200e:	6942                	ld	s2,16(sp)
    80002010:	69a2                	ld	s3,8(sp)
    80002012:	6145                	addi	sp,sp,48
    80002014:	8082                	ret

0000000080002016 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000201e:	fec40593          	addi	a1,s0,-20
    80002022:	4501                	li	a0,0
    80002024:	00000097          	auipc	ra,0x0
    80002028:	ede080e7          	jalr	-290(ra) # 80001f02 <argint>
    return -1;
    8000202c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000202e:	00054963          	bltz	a0,80002040 <sys_exit+0x2a>
  exit(n);
    80002032:	fec42503          	lw	a0,-20(s0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	736080e7          	jalr	1846(ra) # 8000176c <exit>
  return 0;  // not reached
    8000203e:	4781                	li	a5,0
}
    80002040:	853e                	mv	a0,a5
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000204a:	1141                	addi	sp,sp,-16
    8000204c:	e406                	sd	ra,8(sp)
    8000204e:	e022                	sd	s0,0(sp)
    80002050:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	df2080e7          	jalr	-526(ra) # 80000e44 <myproc>
}
    8000205a:	5908                	lw	a0,48(a0)
    8000205c:	60a2                	ld	ra,8(sp)
    8000205e:	6402                	ld	s0,0(sp)
    80002060:	0141                	addi	sp,sp,16
    80002062:	8082                	ret

0000000080002064 <sys_fork>:

uint64
sys_fork(void)
{
    80002064:	1141                	addi	sp,sp,-16
    80002066:	e406                	sd	ra,8(sp)
    80002068:	e022                	sd	s0,0(sp)
    8000206a:	0800                	addi	s0,sp,16
  return fork();
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	1aa080e7          	jalr	426(ra) # 80001216 <fork>
}
    80002074:	60a2                	ld	ra,8(sp)
    80002076:	6402                	ld	s0,0(sp)
    80002078:	0141                	addi	sp,sp,16
    8000207a:	8082                	ret

000000008000207c <sys_wait>:

uint64
sys_wait(void)
{
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002084:	fe840593          	addi	a1,s0,-24
    80002088:	4501                	li	a0,0
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	e9a080e7          	jalr	-358(ra) # 80001f24 <argaddr>
    80002092:	87aa                	mv	a5,a0
    return -1;
    80002094:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002096:	0007c863          	bltz	a5,800020a6 <sys_wait+0x2a>
  return wait(p);
    8000209a:	fe843503          	ld	a0,-24(s0)
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	4d6080e7          	jalr	1238(ra) # 80001574 <wait>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020ae:	7179                	addi	sp,sp,-48
    800020b0:	f406                	sd	ra,40(sp)
    800020b2:	f022                	sd	s0,32(sp)
    800020b4:	ec26                	sd	s1,24(sp)
    800020b6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020b8:	fdc40593          	addi	a1,s0,-36
    800020bc:	4501                	li	a0,0
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	e44080e7          	jalr	-444(ra) # 80001f02 <argint>
    800020c6:	87aa                	mv	a5,a0
    return -1;
    800020c8:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020ca:	0207c063          	bltz	a5,800020ea <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	d76080e7          	jalr	-650(ra) # 80000e44 <myproc>
    800020d6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020d8:	fdc42503          	lw	a0,-36(s0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	0c2080e7          	jalr	194(ra) # 8000119e <growproc>
    800020e4:	00054863          	bltz	a0,800020f4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020e8:	8526                	mv	a0,s1
}
    800020ea:	70a2                	ld	ra,40(sp)
    800020ec:	7402                	ld	s0,32(sp)
    800020ee:	64e2                	ld	s1,24(sp)
    800020f0:	6145                	addi	sp,sp,48
    800020f2:	8082                	ret
    return -1;
    800020f4:	557d                	li	a0,-1
    800020f6:	bfd5                	j	800020ea <sys_sbrk+0x3c>

00000000800020f8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020f8:	7139                	addi	sp,sp,-64
    800020fa:	fc06                	sd	ra,56(sp)
    800020fc:	f822                	sd	s0,48(sp)
    800020fe:	f426                	sd	s1,40(sp)
    80002100:	f04a                	sd	s2,32(sp)
    80002102:	ec4e                	sd	s3,24(sp)
    80002104:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002106:	fcc40593          	addi	a1,s0,-52
    8000210a:	4501                	li	a0,0
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	df6080e7          	jalr	-522(ra) # 80001f02 <argint>
    return -1;
    80002114:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002116:	06054563          	bltz	a0,80002180 <sys_sleep+0x88>
  acquire(&tickslock);
    8000211a:	0000d517          	auipc	a0,0xd
    8000211e:	d6650513          	addi	a0,a0,-666 # 8000ee80 <tickslock>
    80002122:	00004097          	auipc	ra,0x4
    80002126:	f66080e7          	jalr	-154(ra) # 80006088 <acquire>
  ticks0 = ticks;
    8000212a:	00007917          	auipc	s2,0x7
    8000212e:	eee92903          	lw	s2,-274(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002132:	fcc42783          	lw	a5,-52(s0)
    80002136:	cf85                	beqz	a5,8000216e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002138:	0000d997          	auipc	s3,0xd
    8000213c:	d4898993          	addi	s3,s3,-696 # 8000ee80 <tickslock>
    80002140:	00007497          	auipc	s1,0x7
    80002144:	ed848493          	addi	s1,s1,-296 # 80009018 <ticks>
    if(myproc()->killed){
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	cfc080e7          	jalr	-772(ra) # 80000e44 <myproc>
    80002150:	551c                	lw	a5,40(a0)
    80002152:	ef9d                	bnez	a5,80002190 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002154:	85ce                	mv	a1,s3
    80002156:	8526                	mv	a0,s1
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	3b8080e7          	jalr	952(ra) # 80001510 <sleep>
  while(ticks - ticks0 < n){
    80002160:	409c                	lw	a5,0(s1)
    80002162:	412787bb          	subw	a5,a5,s2
    80002166:	fcc42703          	lw	a4,-52(s0)
    8000216a:	fce7efe3          	bltu	a5,a4,80002148 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000216e:	0000d517          	auipc	a0,0xd
    80002172:	d1250513          	addi	a0,a0,-750 # 8000ee80 <tickslock>
    80002176:	00004097          	auipc	ra,0x4
    8000217a:	fc6080e7          	jalr	-58(ra) # 8000613c <release>
  return 0;
    8000217e:	4781                	li	a5,0
}
    80002180:	853e                	mv	a0,a5
    80002182:	70e2                	ld	ra,56(sp)
    80002184:	7442                	ld	s0,48(sp)
    80002186:	74a2                	ld	s1,40(sp)
    80002188:	7902                	ld	s2,32(sp)
    8000218a:	69e2                	ld	s3,24(sp)
    8000218c:	6121                	addi	sp,sp,64
    8000218e:	8082                	ret
      release(&tickslock);
    80002190:	0000d517          	auipc	a0,0xd
    80002194:	cf050513          	addi	a0,a0,-784 # 8000ee80 <tickslock>
    80002198:	00004097          	auipc	ra,0x4
    8000219c:	fa4080e7          	jalr	-92(ra) # 8000613c <release>
      return -1;
    800021a0:	57fd                	li	a5,-1
    800021a2:	bff9                	j	80002180 <sys_sleep+0x88>

00000000800021a4 <sys_kill>:

uint64
sys_kill(void)
{
    800021a4:	1101                	addi	sp,sp,-32
    800021a6:	ec06                	sd	ra,24(sp)
    800021a8:	e822                	sd	s0,16(sp)
    800021aa:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021ac:	fec40593          	addi	a1,s0,-20
    800021b0:	4501                	li	a0,0
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	d50080e7          	jalr	-688(ra) # 80001f02 <argint>
    800021ba:	87aa                	mv	a5,a0
    return -1;
    800021bc:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021be:	0007c863          	bltz	a5,800021ce <sys_kill+0x2a>
  return kill(pid);
    800021c2:	fec42503          	lw	a0,-20(s0)
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	67c080e7          	jalr	1660(ra) # 80001842 <kill>
}
    800021ce:	60e2                	ld	ra,24(sp)
    800021d0:	6442                	ld	s0,16(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021d6:	1101                	addi	sp,sp,-32
    800021d8:	ec06                	sd	ra,24(sp)
    800021da:	e822                	sd	s0,16(sp)
    800021dc:	e426                	sd	s1,8(sp)
    800021de:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021e0:	0000d517          	auipc	a0,0xd
    800021e4:	ca050513          	addi	a0,a0,-864 # 8000ee80 <tickslock>
    800021e8:	00004097          	auipc	ra,0x4
    800021ec:	ea0080e7          	jalr	-352(ra) # 80006088 <acquire>
  xticks = ticks;
    800021f0:	00007497          	auipc	s1,0x7
    800021f4:	e284a483          	lw	s1,-472(s1) # 80009018 <ticks>
  release(&tickslock);
    800021f8:	0000d517          	auipc	a0,0xd
    800021fc:	c8850513          	addi	a0,a0,-888 # 8000ee80 <tickslock>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	f3c080e7          	jalr	-196(ra) # 8000613c <release>
  return xticks;
}
    80002208:	02049513          	slli	a0,s1,0x20
    8000220c:	9101                	srli	a0,a0,0x20
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret

0000000080002218 <sys_trace>:
uint64
sys_trace(void){
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0,&n) < 0)
    80002220:	fec40593          	addi	a1,s0,-20
    80002224:	4501                	li	a0,0
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	cdc080e7          	jalr	-804(ra) # 80001f02 <argint>
    return -1;
    8000222e:	57fd                	li	a5,-1
  if(argint(0,&n) < 0)
    80002230:	00054a63          	bltz	a0,80002244 <sys_trace+0x2c>
  myproc()->mask = n;
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	c10080e7          	jalr	-1008(ra) # 80000e44 <myproc>
    8000223c:	fec42783          	lw	a5,-20(s0)
    80002240:	d95c                	sw	a5,52(a0)
  return 0;
    80002242:	4781                	li	a5,0
}
    80002244:	853e                	mv	a0,a5
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000224e:	7179                	addi	sp,sp,-48
    80002250:	f406                	sd	ra,40(sp)
    80002252:	f022                	sd	s0,32(sp)
    80002254:	ec26                	sd	s1,24(sp)
    80002256:	e84a                	sd	s2,16(sp)
    80002258:	e44e                	sd	s3,8(sp)
    8000225a:	e052                	sd	s4,0(sp)
    8000225c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000225e:	00006597          	auipc	a1,0x6
    80002262:	2ea58593          	addi	a1,a1,746 # 80008548 <syscalls+0xb8>
    80002266:	0000d517          	auipc	a0,0xd
    8000226a:	c3250513          	addi	a0,a0,-974 # 8000ee98 <bcache>
    8000226e:	00004097          	auipc	ra,0x4
    80002272:	d8a080e7          	jalr	-630(ra) # 80005ff8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002276:	00015797          	auipc	a5,0x15
    8000227a:	c2278793          	addi	a5,a5,-990 # 80016e98 <bcache+0x8000>
    8000227e:	00015717          	auipc	a4,0x15
    80002282:	e8270713          	addi	a4,a4,-382 # 80017100 <bcache+0x8268>
    80002286:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000228a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000228e:	0000d497          	auipc	s1,0xd
    80002292:	c2248493          	addi	s1,s1,-990 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002296:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002298:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000229a:	00006a17          	auipc	s4,0x6
    8000229e:	2b6a0a13          	addi	s4,s4,694 # 80008550 <syscalls+0xc0>
    b->next = bcache.head.next;
    800022a2:	2b893783          	ld	a5,696(s2)
    800022a6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022ac:	85d2                	mv	a1,s4
    800022ae:	01048513          	addi	a0,s1,16
    800022b2:	00001097          	auipc	ra,0x1
    800022b6:	4c2080e7          	jalr	1218(ra) # 80003774 <initsleeplock>
    bcache.head.next->prev = b;
    800022ba:	2b893783          	ld	a5,696(s2)
    800022be:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022c0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022c4:	45848493          	addi	s1,s1,1112
    800022c8:	fd349de3          	bne	s1,s3,800022a2 <binit+0x54>
  }
}
    800022cc:	70a2                	ld	ra,40(sp)
    800022ce:	7402                	ld	s0,32(sp)
    800022d0:	64e2                	ld	s1,24(sp)
    800022d2:	6942                	ld	s2,16(sp)
    800022d4:	69a2                	ld	s3,8(sp)
    800022d6:	6a02                	ld	s4,0(sp)
    800022d8:	6145                	addi	sp,sp,48
    800022da:	8082                	ret

00000000800022dc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022dc:	7179                	addi	sp,sp,-48
    800022de:	f406                	sd	ra,40(sp)
    800022e0:	f022                	sd	s0,32(sp)
    800022e2:	ec26                	sd	s1,24(sp)
    800022e4:	e84a                	sd	s2,16(sp)
    800022e6:	e44e                	sd	s3,8(sp)
    800022e8:	1800                	addi	s0,sp,48
    800022ea:	892a                	mv	s2,a0
    800022ec:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ee:	0000d517          	auipc	a0,0xd
    800022f2:	baa50513          	addi	a0,a0,-1110 # 8000ee98 <bcache>
    800022f6:	00004097          	auipc	ra,0x4
    800022fa:	d92080e7          	jalr	-622(ra) # 80006088 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022fe:	00015497          	auipc	s1,0x15
    80002302:	e524b483          	ld	s1,-430(s1) # 80017150 <bcache+0x82b8>
    80002306:	00015797          	auipc	a5,0x15
    8000230a:	dfa78793          	addi	a5,a5,-518 # 80017100 <bcache+0x8268>
    8000230e:	02f48f63          	beq	s1,a5,8000234c <bread+0x70>
    80002312:	873e                	mv	a4,a5
    80002314:	a021                	j	8000231c <bread+0x40>
    80002316:	68a4                	ld	s1,80(s1)
    80002318:	02e48a63          	beq	s1,a4,8000234c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000231c:	449c                	lw	a5,8(s1)
    8000231e:	ff279ce3          	bne	a5,s2,80002316 <bread+0x3a>
    80002322:	44dc                	lw	a5,12(s1)
    80002324:	ff3799e3          	bne	a5,s3,80002316 <bread+0x3a>
      b->refcnt++;
    80002328:	40bc                	lw	a5,64(s1)
    8000232a:	2785                	addiw	a5,a5,1
    8000232c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000232e:	0000d517          	auipc	a0,0xd
    80002332:	b6a50513          	addi	a0,a0,-1174 # 8000ee98 <bcache>
    80002336:	00004097          	auipc	ra,0x4
    8000233a:	e06080e7          	jalr	-506(ra) # 8000613c <release>
      acquiresleep(&b->lock);
    8000233e:	01048513          	addi	a0,s1,16
    80002342:	00001097          	auipc	ra,0x1
    80002346:	46c080e7          	jalr	1132(ra) # 800037ae <acquiresleep>
      return b;
    8000234a:	a8b9                	j	800023a8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000234c:	00015497          	auipc	s1,0x15
    80002350:	dfc4b483          	ld	s1,-516(s1) # 80017148 <bcache+0x82b0>
    80002354:	00015797          	auipc	a5,0x15
    80002358:	dac78793          	addi	a5,a5,-596 # 80017100 <bcache+0x8268>
    8000235c:	00f48863          	beq	s1,a5,8000236c <bread+0x90>
    80002360:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002362:	40bc                	lw	a5,64(s1)
    80002364:	cf81                	beqz	a5,8000237c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002366:	64a4                	ld	s1,72(s1)
    80002368:	fee49de3          	bne	s1,a4,80002362 <bread+0x86>
  panic("bget: no buffers");
    8000236c:	00006517          	auipc	a0,0x6
    80002370:	1ec50513          	addi	a0,a0,492 # 80008558 <syscalls+0xc8>
    80002374:	00003097          	auipc	ra,0x3
    80002378:	7dc080e7          	jalr	2012(ra) # 80005b50 <panic>
      b->dev = dev;
    8000237c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002380:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002384:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002388:	4785                	li	a5,1
    8000238a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000238c:	0000d517          	auipc	a0,0xd
    80002390:	b0c50513          	addi	a0,a0,-1268 # 8000ee98 <bcache>
    80002394:	00004097          	auipc	ra,0x4
    80002398:	da8080e7          	jalr	-600(ra) # 8000613c <release>
      acquiresleep(&b->lock);
    8000239c:	01048513          	addi	a0,s1,16
    800023a0:	00001097          	auipc	ra,0x1
    800023a4:	40e080e7          	jalr	1038(ra) # 800037ae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a8:	409c                	lw	a5,0(s1)
    800023aa:	cb89                	beqz	a5,800023bc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023ac:	8526                	mv	a0,s1
    800023ae:	70a2                	ld	ra,40(sp)
    800023b0:	7402                	ld	s0,32(sp)
    800023b2:	64e2                	ld	s1,24(sp)
    800023b4:	6942                	ld	s2,16(sp)
    800023b6:	69a2                	ld	s3,8(sp)
    800023b8:	6145                	addi	sp,sp,48
    800023ba:	8082                	ret
    virtio_disk_rw(b, 0);
    800023bc:	4581                	li	a1,0
    800023be:	8526                	mv	a0,s1
    800023c0:	00003097          	auipc	ra,0x3
    800023c4:	f22080e7          	jalr	-222(ra) # 800052e2 <virtio_disk_rw>
    b->valid = 1;
    800023c8:	4785                	li	a5,1
    800023ca:	c09c                	sw	a5,0(s1)
  return b;
    800023cc:	b7c5                	j	800023ac <bread+0xd0>

00000000800023ce <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023ce:	1101                	addi	sp,sp,-32
    800023d0:	ec06                	sd	ra,24(sp)
    800023d2:	e822                	sd	s0,16(sp)
    800023d4:	e426                	sd	s1,8(sp)
    800023d6:	1000                	addi	s0,sp,32
    800023d8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023da:	0541                	addi	a0,a0,16
    800023dc:	00001097          	auipc	ra,0x1
    800023e0:	46c080e7          	jalr	1132(ra) # 80003848 <holdingsleep>
    800023e4:	cd01                	beqz	a0,800023fc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023e6:	4585                	li	a1,1
    800023e8:	8526                	mv	a0,s1
    800023ea:	00003097          	auipc	ra,0x3
    800023ee:	ef8080e7          	jalr	-264(ra) # 800052e2 <virtio_disk_rw>
}
    800023f2:	60e2                	ld	ra,24(sp)
    800023f4:	6442                	ld	s0,16(sp)
    800023f6:	64a2                	ld	s1,8(sp)
    800023f8:	6105                	addi	sp,sp,32
    800023fa:	8082                	ret
    panic("bwrite");
    800023fc:	00006517          	auipc	a0,0x6
    80002400:	17450513          	addi	a0,a0,372 # 80008570 <syscalls+0xe0>
    80002404:	00003097          	auipc	ra,0x3
    80002408:	74c080e7          	jalr	1868(ra) # 80005b50 <panic>

000000008000240c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000240c:	1101                	addi	sp,sp,-32
    8000240e:	ec06                	sd	ra,24(sp)
    80002410:	e822                	sd	s0,16(sp)
    80002412:	e426                	sd	s1,8(sp)
    80002414:	e04a                	sd	s2,0(sp)
    80002416:	1000                	addi	s0,sp,32
    80002418:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000241a:	01050913          	addi	s2,a0,16
    8000241e:	854a                	mv	a0,s2
    80002420:	00001097          	auipc	ra,0x1
    80002424:	428080e7          	jalr	1064(ra) # 80003848 <holdingsleep>
    80002428:	c92d                	beqz	a0,8000249a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000242a:	854a                	mv	a0,s2
    8000242c:	00001097          	auipc	ra,0x1
    80002430:	3d8080e7          	jalr	984(ra) # 80003804 <releasesleep>

  acquire(&bcache.lock);
    80002434:	0000d517          	auipc	a0,0xd
    80002438:	a6450513          	addi	a0,a0,-1436 # 8000ee98 <bcache>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	c4c080e7          	jalr	-948(ra) # 80006088 <acquire>
  b->refcnt--;
    80002444:	40bc                	lw	a5,64(s1)
    80002446:	37fd                	addiw	a5,a5,-1
    80002448:	0007871b          	sext.w	a4,a5
    8000244c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000244e:	eb05                	bnez	a4,8000247e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002450:	68bc                	ld	a5,80(s1)
    80002452:	64b8                	ld	a4,72(s1)
    80002454:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002456:	64bc                	ld	a5,72(s1)
    80002458:	68b8                	ld	a4,80(s1)
    8000245a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000245c:	00015797          	auipc	a5,0x15
    80002460:	a3c78793          	addi	a5,a5,-1476 # 80016e98 <bcache+0x8000>
    80002464:	2b87b703          	ld	a4,696(a5)
    80002468:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000246a:	00015717          	auipc	a4,0x15
    8000246e:	c9670713          	addi	a4,a4,-874 # 80017100 <bcache+0x8268>
    80002472:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002474:	2b87b703          	ld	a4,696(a5)
    80002478:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000247a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000247e:	0000d517          	auipc	a0,0xd
    80002482:	a1a50513          	addi	a0,a0,-1510 # 8000ee98 <bcache>
    80002486:	00004097          	auipc	ra,0x4
    8000248a:	cb6080e7          	jalr	-842(ra) # 8000613c <release>
}
    8000248e:	60e2                	ld	ra,24(sp)
    80002490:	6442                	ld	s0,16(sp)
    80002492:	64a2                	ld	s1,8(sp)
    80002494:	6902                	ld	s2,0(sp)
    80002496:	6105                	addi	sp,sp,32
    80002498:	8082                	ret
    panic("brelse");
    8000249a:	00006517          	auipc	a0,0x6
    8000249e:	0de50513          	addi	a0,a0,222 # 80008578 <syscalls+0xe8>
    800024a2:	00003097          	auipc	ra,0x3
    800024a6:	6ae080e7          	jalr	1710(ra) # 80005b50 <panic>

00000000800024aa <bpin>:

void
bpin(struct buf *b) {
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	1000                	addi	s0,sp,32
    800024b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024b6:	0000d517          	auipc	a0,0xd
    800024ba:	9e250513          	addi	a0,a0,-1566 # 8000ee98 <bcache>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	bca080e7          	jalr	-1078(ra) # 80006088 <acquire>
  b->refcnt++;
    800024c6:	40bc                	lw	a5,64(s1)
    800024c8:	2785                	addiw	a5,a5,1
    800024ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024cc:	0000d517          	auipc	a0,0xd
    800024d0:	9cc50513          	addi	a0,a0,-1588 # 8000ee98 <bcache>
    800024d4:	00004097          	auipc	ra,0x4
    800024d8:	c68080e7          	jalr	-920(ra) # 8000613c <release>
}
    800024dc:	60e2                	ld	ra,24(sp)
    800024de:	6442                	ld	s0,16(sp)
    800024e0:	64a2                	ld	s1,8(sp)
    800024e2:	6105                	addi	sp,sp,32
    800024e4:	8082                	ret

00000000800024e6 <bunpin>:

void
bunpin(struct buf *b) {
    800024e6:	1101                	addi	sp,sp,-32
    800024e8:	ec06                	sd	ra,24(sp)
    800024ea:	e822                	sd	s0,16(sp)
    800024ec:	e426                	sd	s1,8(sp)
    800024ee:	1000                	addi	s0,sp,32
    800024f0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024f2:	0000d517          	auipc	a0,0xd
    800024f6:	9a650513          	addi	a0,a0,-1626 # 8000ee98 <bcache>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	b8e080e7          	jalr	-1138(ra) # 80006088 <acquire>
  b->refcnt--;
    80002502:	40bc                	lw	a5,64(s1)
    80002504:	37fd                	addiw	a5,a5,-1
    80002506:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002508:	0000d517          	auipc	a0,0xd
    8000250c:	99050513          	addi	a0,a0,-1648 # 8000ee98 <bcache>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	c2c080e7          	jalr	-980(ra) # 8000613c <release>
}
    80002518:	60e2                	ld	ra,24(sp)
    8000251a:	6442                	ld	s0,16(sp)
    8000251c:	64a2                	ld	s1,8(sp)
    8000251e:	6105                	addi	sp,sp,32
    80002520:	8082                	ret

0000000080002522 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002522:	1101                	addi	sp,sp,-32
    80002524:	ec06                	sd	ra,24(sp)
    80002526:	e822                	sd	s0,16(sp)
    80002528:	e426                	sd	s1,8(sp)
    8000252a:	e04a                	sd	s2,0(sp)
    8000252c:	1000                	addi	s0,sp,32
    8000252e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002530:	00d5d59b          	srliw	a1,a1,0xd
    80002534:	00015797          	auipc	a5,0x15
    80002538:	0407a783          	lw	a5,64(a5) # 80017574 <sb+0x1c>
    8000253c:	9dbd                	addw	a1,a1,a5
    8000253e:	00000097          	auipc	ra,0x0
    80002542:	d9e080e7          	jalr	-610(ra) # 800022dc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002546:	0074f713          	andi	a4,s1,7
    8000254a:	4785                	li	a5,1
    8000254c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002550:	14ce                	slli	s1,s1,0x33
    80002552:	90d9                	srli	s1,s1,0x36
    80002554:	00950733          	add	a4,a0,s1
    80002558:	05874703          	lbu	a4,88(a4)
    8000255c:	00e7f6b3          	and	a3,a5,a4
    80002560:	c69d                	beqz	a3,8000258e <bfree+0x6c>
    80002562:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002564:	94aa                	add	s1,s1,a0
    80002566:	fff7c793          	not	a5,a5
    8000256a:	8f7d                	and	a4,a4,a5
    8000256c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002570:	00001097          	auipc	ra,0x1
    80002574:	120080e7          	jalr	288(ra) # 80003690 <log_write>
  brelse(bp);
    80002578:	854a                	mv	a0,s2
    8000257a:	00000097          	auipc	ra,0x0
    8000257e:	e92080e7          	jalr	-366(ra) # 8000240c <brelse>
}
    80002582:	60e2                	ld	ra,24(sp)
    80002584:	6442                	ld	s0,16(sp)
    80002586:	64a2                	ld	s1,8(sp)
    80002588:	6902                	ld	s2,0(sp)
    8000258a:	6105                	addi	sp,sp,32
    8000258c:	8082                	ret
    panic("freeing free block");
    8000258e:	00006517          	auipc	a0,0x6
    80002592:	ff250513          	addi	a0,a0,-14 # 80008580 <syscalls+0xf0>
    80002596:	00003097          	auipc	ra,0x3
    8000259a:	5ba080e7          	jalr	1466(ra) # 80005b50 <panic>

000000008000259e <balloc>:
{
    8000259e:	711d                	addi	sp,sp,-96
    800025a0:	ec86                	sd	ra,88(sp)
    800025a2:	e8a2                	sd	s0,80(sp)
    800025a4:	e4a6                	sd	s1,72(sp)
    800025a6:	e0ca                	sd	s2,64(sp)
    800025a8:	fc4e                	sd	s3,56(sp)
    800025aa:	f852                	sd	s4,48(sp)
    800025ac:	f456                	sd	s5,40(sp)
    800025ae:	f05a                	sd	s6,32(sp)
    800025b0:	ec5e                	sd	s7,24(sp)
    800025b2:	e862                	sd	s8,16(sp)
    800025b4:	e466                	sd	s9,8(sp)
    800025b6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b8:	00015797          	auipc	a5,0x15
    800025bc:	fa47a783          	lw	a5,-92(a5) # 8001755c <sb+0x4>
    800025c0:	cbc1                	beqz	a5,80002650 <balloc+0xb2>
    800025c2:	8baa                	mv	s7,a0
    800025c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025c6:	00015b17          	auipc	s6,0x15
    800025ca:	f92b0b13          	addi	s6,s6,-110 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ce:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025d4:	6c89                	lui	s9,0x2
    800025d6:	a831                	j	800025f2 <balloc+0x54>
    brelse(bp);
    800025d8:	854a                	mv	a0,s2
    800025da:	00000097          	auipc	ra,0x0
    800025de:	e32080e7          	jalr	-462(ra) # 8000240c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025e2:	015c87bb          	addw	a5,s9,s5
    800025e6:	00078a9b          	sext.w	s5,a5
    800025ea:	004b2703          	lw	a4,4(s6)
    800025ee:	06eaf163          	bgeu	s5,a4,80002650 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800025f2:	41fad79b          	sraiw	a5,s5,0x1f
    800025f6:	0137d79b          	srliw	a5,a5,0x13
    800025fa:	015787bb          	addw	a5,a5,s5
    800025fe:	40d7d79b          	sraiw	a5,a5,0xd
    80002602:	01cb2583          	lw	a1,28(s6)
    80002606:	9dbd                	addw	a1,a1,a5
    80002608:	855e                	mv	a0,s7
    8000260a:	00000097          	auipc	ra,0x0
    8000260e:	cd2080e7          	jalr	-814(ra) # 800022dc <bread>
    80002612:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002614:	004b2503          	lw	a0,4(s6)
    80002618:	000a849b          	sext.w	s1,s5
    8000261c:	8762                	mv	a4,s8
    8000261e:	faa4fde3          	bgeu	s1,a0,800025d8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002622:	00777693          	andi	a3,a4,7
    80002626:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000262a:	41f7579b          	sraiw	a5,a4,0x1f
    8000262e:	01d7d79b          	srliw	a5,a5,0x1d
    80002632:	9fb9                	addw	a5,a5,a4
    80002634:	4037d79b          	sraiw	a5,a5,0x3
    80002638:	00f90633          	add	a2,s2,a5
    8000263c:	05864603          	lbu	a2,88(a2)
    80002640:	00c6f5b3          	and	a1,a3,a2
    80002644:	cd91                	beqz	a1,80002660 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002646:	2705                	addiw	a4,a4,1
    80002648:	2485                	addiw	s1,s1,1
    8000264a:	fd471ae3          	bne	a4,s4,8000261e <balloc+0x80>
    8000264e:	b769                	j	800025d8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002650:	00006517          	auipc	a0,0x6
    80002654:	f4850513          	addi	a0,a0,-184 # 80008598 <syscalls+0x108>
    80002658:	00003097          	auipc	ra,0x3
    8000265c:	4f8080e7          	jalr	1272(ra) # 80005b50 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002660:	97ca                	add	a5,a5,s2
    80002662:	8e55                	or	a2,a2,a3
    80002664:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002668:	854a                	mv	a0,s2
    8000266a:	00001097          	auipc	ra,0x1
    8000266e:	026080e7          	jalr	38(ra) # 80003690 <log_write>
        brelse(bp);
    80002672:	854a                	mv	a0,s2
    80002674:	00000097          	auipc	ra,0x0
    80002678:	d98080e7          	jalr	-616(ra) # 8000240c <brelse>
  bp = bread(dev, bno);
    8000267c:	85a6                	mv	a1,s1
    8000267e:	855e                	mv	a0,s7
    80002680:	00000097          	auipc	ra,0x0
    80002684:	c5c080e7          	jalr	-932(ra) # 800022dc <bread>
    80002688:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000268a:	40000613          	li	a2,1024
    8000268e:	4581                	li	a1,0
    80002690:	05850513          	addi	a0,a0,88
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	ae6080e7          	jalr	-1306(ra) # 8000017a <memset>
  log_write(bp);
    8000269c:	854a                	mv	a0,s2
    8000269e:	00001097          	auipc	ra,0x1
    800026a2:	ff2080e7          	jalr	-14(ra) # 80003690 <log_write>
  brelse(bp);
    800026a6:	854a                	mv	a0,s2
    800026a8:	00000097          	auipc	ra,0x0
    800026ac:	d64080e7          	jalr	-668(ra) # 8000240c <brelse>
}
    800026b0:	8526                	mv	a0,s1
    800026b2:	60e6                	ld	ra,88(sp)
    800026b4:	6446                	ld	s0,80(sp)
    800026b6:	64a6                	ld	s1,72(sp)
    800026b8:	6906                	ld	s2,64(sp)
    800026ba:	79e2                	ld	s3,56(sp)
    800026bc:	7a42                	ld	s4,48(sp)
    800026be:	7aa2                	ld	s5,40(sp)
    800026c0:	7b02                	ld	s6,32(sp)
    800026c2:	6be2                	ld	s7,24(sp)
    800026c4:	6c42                	ld	s8,16(sp)
    800026c6:	6ca2                	ld	s9,8(sp)
    800026c8:	6125                	addi	sp,sp,96
    800026ca:	8082                	ret

00000000800026cc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026cc:	7179                	addi	sp,sp,-48
    800026ce:	f406                	sd	ra,40(sp)
    800026d0:	f022                	sd	s0,32(sp)
    800026d2:	ec26                	sd	s1,24(sp)
    800026d4:	e84a                	sd	s2,16(sp)
    800026d6:	e44e                	sd	s3,8(sp)
    800026d8:	e052                	sd	s4,0(sp)
    800026da:	1800                	addi	s0,sp,48
    800026dc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026de:	47ad                	li	a5,11
    800026e0:	04b7fe63          	bgeu	a5,a1,8000273c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026e4:	ff45849b          	addiw	s1,a1,-12
    800026e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026ec:	0ff00793          	li	a5,255
    800026f0:	0ae7e463          	bltu	a5,a4,80002798 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026f4:	08052583          	lw	a1,128(a0)
    800026f8:	c5b5                	beqz	a1,80002764 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026fa:	00092503          	lw	a0,0(s2)
    800026fe:	00000097          	auipc	ra,0x0
    80002702:	bde080e7          	jalr	-1058(ra) # 800022dc <bread>
    80002706:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002708:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000270c:	02049713          	slli	a4,s1,0x20
    80002710:	01e75593          	srli	a1,a4,0x1e
    80002714:	00b784b3          	add	s1,a5,a1
    80002718:	0004a983          	lw	s3,0(s1)
    8000271c:	04098e63          	beqz	s3,80002778 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002720:	8552                	mv	a0,s4
    80002722:	00000097          	auipc	ra,0x0
    80002726:	cea080e7          	jalr	-790(ra) # 8000240c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000272a:	854e                	mv	a0,s3
    8000272c:	70a2                	ld	ra,40(sp)
    8000272e:	7402                	ld	s0,32(sp)
    80002730:	64e2                	ld	s1,24(sp)
    80002732:	6942                	ld	s2,16(sp)
    80002734:	69a2                	ld	s3,8(sp)
    80002736:	6a02                	ld	s4,0(sp)
    80002738:	6145                	addi	sp,sp,48
    8000273a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000273c:	02059793          	slli	a5,a1,0x20
    80002740:	01e7d593          	srli	a1,a5,0x1e
    80002744:	00b504b3          	add	s1,a0,a1
    80002748:	0504a983          	lw	s3,80(s1)
    8000274c:	fc099fe3          	bnez	s3,8000272a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002750:	4108                	lw	a0,0(a0)
    80002752:	00000097          	auipc	ra,0x0
    80002756:	e4c080e7          	jalr	-436(ra) # 8000259e <balloc>
    8000275a:	0005099b          	sext.w	s3,a0
    8000275e:	0534a823          	sw	s3,80(s1)
    80002762:	b7e1                	j	8000272a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002764:	4108                	lw	a0,0(a0)
    80002766:	00000097          	auipc	ra,0x0
    8000276a:	e38080e7          	jalr	-456(ra) # 8000259e <balloc>
    8000276e:	0005059b          	sext.w	a1,a0
    80002772:	08b92023          	sw	a1,128(s2)
    80002776:	b751                	j	800026fa <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002778:	00092503          	lw	a0,0(s2)
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	e22080e7          	jalr	-478(ra) # 8000259e <balloc>
    80002784:	0005099b          	sext.w	s3,a0
    80002788:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000278c:	8552                	mv	a0,s4
    8000278e:	00001097          	auipc	ra,0x1
    80002792:	f02080e7          	jalr	-254(ra) # 80003690 <log_write>
    80002796:	b769                	j	80002720 <bmap+0x54>
  panic("bmap: out of range");
    80002798:	00006517          	auipc	a0,0x6
    8000279c:	e1850513          	addi	a0,a0,-488 # 800085b0 <syscalls+0x120>
    800027a0:	00003097          	auipc	ra,0x3
    800027a4:	3b0080e7          	jalr	944(ra) # 80005b50 <panic>

00000000800027a8 <iget>:
{
    800027a8:	7179                	addi	sp,sp,-48
    800027aa:	f406                	sd	ra,40(sp)
    800027ac:	f022                	sd	s0,32(sp)
    800027ae:	ec26                	sd	s1,24(sp)
    800027b0:	e84a                	sd	s2,16(sp)
    800027b2:	e44e                	sd	s3,8(sp)
    800027b4:	e052                	sd	s4,0(sp)
    800027b6:	1800                	addi	s0,sp,48
    800027b8:	89aa                	mv	s3,a0
    800027ba:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027bc:	00015517          	auipc	a0,0x15
    800027c0:	dbc50513          	addi	a0,a0,-580 # 80017578 <itable>
    800027c4:	00004097          	auipc	ra,0x4
    800027c8:	8c4080e7          	jalr	-1852(ra) # 80006088 <acquire>
  empty = 0;
    800027cc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027ce:	00015497          	auipc	s1,0x15
    800027d2:	dc248493          	addi	s1,s1,-574 # 80017590 <itable+0x18>
    800027d6:	00017697          	auipc	a3,0x17
    800027da:	84a68693          	addi	a3,a3,-1974 # 80019020 <log>
    800027de:	a039                	j	800027ec <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027e0:	02090b63          	beqz	s2,80002816 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e4:	08848493          	addi	s1,s1,136
    800027e8:	02d48a63          	beq	s1,a3,8000281c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ec:	449c                	lw	a5,8(s1)
    800027ee:	fef059e3          	blez	a5,800027e0 <iget+0x38>
    800027f2:	4098                	lw	a4,0(s1)
    800027f4:	ff3716e3          	bne	a4,s3,800027e0 <iget+0x38>
    800027f8:	40d8                	lw	a4,4(s1)
    800027fa:	ff4713e3          	bne	a4,s4,800027e0 <iget+0x38>
      ip->ref++;
    800027fe:	2785                	addiw	a5,a5,1
    80002800:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002802:	00015517          	auipc	a0,0x15
    80002806:	d7650513          	addi	a0,a0,-650 # 80017578 <itable>
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	932080e7          	jalr	-1742(ra) # 8000613c <release>
      return ip;
    80002812:	8926                	mv	s2,s1
    80002814:	a03d                	j	80002842 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002816:	f7f9                	bnez	a5,800027e4 <iget+0x3c>
    80002818:	8926                	mv	s2,s1
    8000281a:	b7e9                	j	800027e4 <iget+0x3c>
  if(empty == 0)
    8000281c:	02090c63          	beqz	s2,80002854 <iget+0xac>
  ip->dev = dev;
    80002820:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002824:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002828:	4785                	li	a5,1
    8000282a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000282e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002832:	00015517          	auipc	a0,0x15
    80002836:	d4650513          	addi	a0,a0,-698 # 80017578 <itable>
    8000283a:	00004097          	auipc	ra,0x4
    8000283e:	902080e7          	jalr	-1790(ra) # 8000613c <release>
}
    80002842:	854a                	mv	a0,s2
    80002844:	70a2                	ld	ra,40(sp)
    80002846:	7402                	ld	s0,32(sp)
    80002848:	64e2                	ld	s1,24(sp)
    8000284a:	6942                	ld	s2,16(sp)
    8000284c:	69a2                	ld	s3,8(sp)
    8000284e:	6a02                	ld	s4,0(sp)
    80002850:	6145                	addi	sp,sp,48
    80002852:	8082                	ret
    panic("iget: no inodes");
    80002854:	00006517          	auipc	a0,0x6
    80002858:	d7450513          	addi	a0,a0,-652 # 800085c8 <syscalls+0x138>
    8000285c:	00003097          	auipc	ra,0x3
    80002860:	2f4080e7          	jalr	756(ra) # 80005b50 <panic>

0000000080002864 <fsinit>:
fsinit(int dev) {
    80002864:	7179                	addi	sp,sp,-48
    80002866:	f406                	sd	ra,40(sp)
    80002868:	f022                	sd	s0,32(sp)
    8000286a:	ec26                	sd	s1,24(sp)
    8000286c:	e84a                	sd	s2,16(sp)
    8000286e:	e44e                	sd	s3,8(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002874:	4585                	li	a1,1
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	a66080e7          	jalr	-1434(ra) # 800022dc <bread>
    8000287e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002880:	00015997          	auipc	s3,0x15
    80002884:	cd898993          	addi	s3,s3,-808 # 80017558 <sb>
    80002888:	02000613          	li	a2,32
    8000288c:	05850593          	addi	a1,a0,88
    80002890:	854e                	mv	a0,s3
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	944080e7          	jalr	-1724(ra) # 800001d6 <memmove>
  brelse(bp);
    8000289a:	8526                	mv	a0,s1
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	b70080e7          	jalr	-1168(ra) # 8000240c <brelse>
  if(sb.magic != FSMAGIC)
    800028a4:	0009a703          	lw	a4,0(s3)
    800028a8:	102037b7          	lui	a5,0x10203
    800028ac:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028b0:	02f71263          	bne	a4,a5,800028d4 <fsinit+0x70>
  initlog(dev, &sb);
    800028b4:	00015597          	auipc	a1,0x15
    800028b8:	ca458593          	addi	a1,a1,-860 # 80017558 <sb>
    800028bc:	854a                	mv	a0,s2
    800028be:	00001097          	auipc	ra,0x1
    800028c2:	b56080e7          	jalr	-1194(ra) # 80003414 <initlog>
}
    800028c6:	70a2                	ld	ra,40(sp)
    800028c8:	7402                	ld	s0,32(sp)
    800028ca:	64e2                	ld	s1,24(sp)
    800028cc:	6942                	ld	s2,16(sp)
    800028ce:	69a2                	ld	s3,8(sp)
    800028d0:	6145                	addi	sp,sp,48
    800028d2:	8082                	ret
    panic("invalid file system");
    800028d4:	00006517          	auipc	a0,0x6
    800028d8:	d0450513          	addi	a0,a0,-764 # 800085d8 <syscalls+0x148>
    800028dc:	00003097          	auipc	ra,0x3
    800028e0:	274080e7          	jalr	628(ra) # 80005b50 <panic>

00000000800028e4 <iinit>:
{
    800028e4:	7179                	addi	sp,sp,-48
    800028e6:	f406                	sd	ra,40(sp)
    800028e8:	f022                	sd	s0,32(sp)
    800028ea:	ec26                	sd	s1,24(sp)
    800028ec:	e84a                	sd	s2,16(sp)
    800028ee:	e44e                	sd	s3,8(sp)
    800028f0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028f2:	00006597          	auipc	a1,0x6
    800028f6:	cfe58593          	addi	a1,a1,-770 # 800085f0 <syscalls+0x160>
    800028fa:	00015517          	auipc	a0,0x15
    800028fe:	c7e50513          	addi	a0,a0,-898 # 80017578 <itable>
    80002902:	00003097          	auipc	ra,0x3
    80002906:	6f6080e7          	jalr	1782(ra) # 80005ff8 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000290a:	00015497          	auipc	s1,0x15
    8000290e:	c9648493          	addi	s1,s1,-874 # 800175a0 <itable+0x28>
    80002912:	00016997          	auipc	s3,0x16
    80002916:	71e98993          	addi	s3,s3,1822 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000291a:	00006917          	auipc	s2,0x6
    8000291e:	cde90913          	addi	s2,s2,-802 # 800085f8 <syscalls+0x168>
    80002922:	85ca                	mv	a1,s2
    80002924:	8526                	mv	a0,s1
    80002926:	00001097          	auipc	ra,0x1
    8000292a:	e4e080e7          	jalr	-434(ra) # 80003774 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000292e:	08848493          	addi	s1,s1,136
    80002932:	ff3498e3          	bne	s1,s3,80002922 <iinit+0x3e>
}
    80002936:	70a2                	ld	ra,40(sp)
    80002938:	7402                	ld	s0,32(sp)
    8000293a:	64e2                	ld	s1,24(sp)
    8000293c:	6942                	ld	s2,16(sp)
    8000293e:	69a2                	ld	s3,8(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret

0000000080002944 <ialloc>:
{
    80002944:	715d                	addi	sp,sp,-80
    80002946:	e486                	sd	ra,72(sp)
    80002948:	e0a2                	sd	s0,64(sp)
    8000294a:	fc26                	sd	s1,56(sp)
    8000294c:	f84a                	sd	s2,48(sp)
    8000294e:	f44e                	sd	s3,40(sp)
    80002950:	f052                	sd	s4,32(sp)
    80002952:	ec56                	sd	s5,24(sp)
    80002954:	e85a                	sd	s6,16(sp)
    80002956:	e45e                	sd	s7,8(sp)
    80002958:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000295a:	00015717          	auipc	a4,0x15
    8000295e:	c0a72703          	lw	a4,-1014(a4) # 80017564 <sb+0xc>
    80002962:	4785                	li	a5,1
    80002964:	04e7fa63          	bgeu	a5,a4,800029b8 <ialloc+0x74>
    80002968:	8aaa                	mv	s5,a0
    8000296a:	8bae                	mv	s7,a1
    8000296c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000296e:	00015a17          	auipc	s4,0x15
    80002972:	beaa0a13          	addi	s4,s4,-1046 # 80017558 <sb>
    80002976:	00048b1b          	sext.w	s6,s1
    8000297a:	0044d593          	srli	a1,s1,0x4
    8000297e:	018a2783          	lw	a5,24(s4)
    80002982:	9dbd                	addw	a1,a1,a5
    80002984:	8556                	mv	a0,s5
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	956080e7          	jalr	-1706(ra) # 800022dc <bread>
    8000298e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002990:	05850993          	addi	s3,a0,88
    80002994:	00f4f793          	andi	a5,s1,15
    80002998:	079a                	slli	a5,a5,0x6
    8000299a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000299c:	00099783          	lh	a5,0(s3)
    800029a0:	c785                	beqz	a5,800029c8 <ialloc+0x84>
    brelse(bp);
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	a6a080e7          	jalr	-1430(ra) # 8000240c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029aa:	0485                	addi	s1,s1,1
    800029ac:	00ca2703          	lw	a4,12(s4)
    800029b0:	0004879b          	sext.w	a5,s1
    800029b4:	fce7e1e3          	bltu	a5,a4,80002976 <ialloc+0x32>
  panic("ialloc: no inodes");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	c4850513          	addi	a0,a0,-952 # 80008600 <syscalls+0x170>
    800029c0:	00003097          	auipc	ra,0x3
    800029c4:	190080e7          	jalr	400(ra) # 80005b50 <panic>
      memset(dip, 0, sizeof(*dip));
    800029c8:	04000613          	li	a2,64
    800029cc:	4581                	li	a1,0
    800029ce:	854e                	mv	a0,s3
    800029d0:	ffffd097          	auipc	ra,0xffffd
    800029d4:	7aa080e7          	jalr	1962(ra) # 8000017a <memset>
      dip->type = type;
    800029d8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029dc:	854a                	mv	a0,s2
    800029de:	00001097          	auipc	ra,0x1
    800029e2:	cb2080e7          	jalr	-846(ra) # 80003690 <log_write>
      brelse(bp);
    800029e6:	854a                	mv	a0,s2
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	a24080e7          	jalr	-1500(ra) # 8000240c <brelse>
      return iget(dev, inum);
    800029f0:	85da                	mv	a1,s6
    800029f2:	8556                	mv	a0,s5
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	db4080e7          	jalr	-588(ra) # 800027a8 <iget>
}
    800029fc:	60a6                	ld	ra,72(sp)
    800029fe:	6406                	ld	s0,64(sp)
    80002a00:	74e2                	ld	s1,56(sp)
    80002a02:	7942                	ld	s2,48(sp)
    80002a04:	79a2                	ld	s3,40(sp)
    80002a06:	7a02                	ld	s4,32(sp)
    80002a08:	6ae2                	ld	s5,24(sp)
    80002a0a:	6b42                	ld	s6,16(sp)
    80002a0c:	6ba2                	ld	s7,8(sp)
    80002a0e:	6161                	addi	sp,sp,80
    80002a10:	8082                	ret

0000000080002a12 <iupdate>:
{
    80002a12:	1101                	addi	sp,sp,-32
    80002a14:	ec06                	sd	ra,24(sp)
    80002a16:	e822                	sd	s0,16(sp)
    80002a18:	e426                	sd	s1,8(sp)
    80002a1a:	e04a                	sd	s2,0(sp)
    80002a1c:	1000                	addi	s0,sp,32
    80002a1e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a20:	415c                	lw	a5,4(a0)
    80002a22:	0047d79b          	srliw	a5,a5,0x4
    80002a26:	00015597          	auipc	a1,0x15
    80002a2a:	b4a5a583          	lw	a1,-1206(a1) # 80017570 <sb+0x18>
    80002a2e:	9dbd                	addw	a1,a1,a5
    80002a30:	4108                	lw	a0,0(a0)
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	8aa080e7          	jalr	-1878(ra) # 800022dc <bread>
    80002a3a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a3c:	05850793          	addi	a5,a0,88
    80002a40:	40d8                	lw	a4,4(s1)
    80002a42:	8b3d                	andi	a4,a4,15
    80002a44:	071a                	slli	a4,a4,0x6
    80002a46:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a48:	04449703          	lh	a4,68(s1)
    80002a4c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a50:	04649703          	lh	a4,70(s1)
    80002a54:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a58:	04849703          	lh	a4,72(s1)
    80002a5c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a60:	04a49703          	lh	a4,74(s1)
    80002a64:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a68:	44f8                	lw	a4,76(s1)
    80002a6a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a6c:	03400613          	li	a2,52
    80002a70:	05048593          	addi	a1,s1,80
    80002a74:	00c78513          	addi	a0,a5,12
    80002a78:	ffffd097          	auipc	ra,0xffffd
    80002a7c:	75e080e7          	jalr	1886(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a80:	854a                	mv	a0,s2
    80002a82:	00001097          	auipc	ra,0x1
    80002a86:	c0e080e7          	jalr	-1010(ra) # 80003690 <log_write>
  brelse(bp);
    80002a8a:	854a                	mv	a0,s2
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	980080e7          	jalr	-1664(ra) # 8000240c <brelse>
}
    80002a94:	60e2                	ld	ra,24(sp)
    80002a96:	6442                	ld	s0,16(sp)
    80002a98:	64a2                	ld	s1,8(sp)
    80002a9a:	6902                	ld	s2,0(sp)
    80002a9c:	6105                	addi	sp,sp,32
    80002a9e:	8082                	ret

0000000080002aa0 <idup>:
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	e426                	sd	s1,8(sp)
    80002aa8:	1000                	addi	s0,sp,32
    80002aaa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aac:	00015517          	auipc	a0,0x15
    80002ab0:	acc50513          	addi	a0,a0,-1332 # 80017578 <itable>
    80002ab4:	00003097          	auipc	ra,0x3
    80002ab8:	5d4080e7          	jalr	1492(ra) # 80006088 <acquire>
  ip->ref++;
    80002abc:	449c                	lw	a5,8(s1)
    80002abe:	2785                	addiw	a5,a5,1
    80002ac0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ac2:	00015517          	auipc	a0,0x15
    80002ac6:	ab650513          	addi	a0,a0,-1354 # 80017578 <itable>
    80002aca:	00003097          	auipc	ra,0x3
    80002ace:	672080e7          	jalr	1650(ra) # 8000613c <release>
}
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	60e2                	ld	ra,24(sp)
    80002ad6:	6442                	ld	s0,16(sp)
    80002ad8:	64a2                	ld	s1,8(sp)
    80002ada:	6105                	addi	sp,sp,32
    80002adc:	8082                	ret

0000000080002ade <ilock>:
{
    80002ade:	1101                	addi	sp,sp,-32
    80002ae0:	ec06                	sd	ra,24(sp)
    80002ae2:	e822                	sd	s0,16(sp)
    80002ae4:	e426                	sd	s1,8(sp)
    80002ae6:	e04a                	sd	s2,0(sp)
    80002ae8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002aea:	c115                	beqz	a0,80002b0e <ilock+0x30>
    80002aec:	84aa                	mv	s1,a0
    80002aee:	451c                	lw	a5,8(a0)
    80002af0:	00f05f63          	blez	a5,80002b0e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002af4:	0541                	addi	a0,a0,16
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	cb8080e7          	jalr	-840(ra) # 800037ae <acquiresleep>
  if(ip->valid == 0){
    80002afe:	40bc                	lw	a5,64(s1)
    80002b00:	cf99                	beqz	a5,80002b1e <ilock+0x40>
}
    80002b02:	60e2                	ld	ra,24(sp)
    80002b04:	6442                	ld	s0,16(sp)
    80002b06:	64a2                	ld	s1,8(sp)
    80002b08:	6902                	ld	s2,0(sp)
    80002b0a:	6105                	addi	sp,sp,32
    80002b0c:	8082                	ret
    panic("ilock");
    80002b0e:	00006517          	auipc	a0,0x6
    80002b12:	b0a50513          	addi	a0,a0,-1270 # 80008618 <syscalls+0x188>
    80002b16:	00003097          	auipc	ra,0x3
    80002b1a:	03a080e7          	jalr	58(ra) # 80005b50 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b1e:	40dc                	lw	a5,4(s1)
    80002b20:	0047d79b          	srliw	a5,a5,0x4
    80002b24:	00015597          	auipc	a1,0x15
    80002b28:	a4c5a583          	lw	a1,-1460(a1) # 80017570 <sb+0x18>
    80002b2c:	9dbd                	addw	a1,a1,a5
    80002b2e:	4088                	lw	a0,0(s1)
    80002b30:	fffff097          	auipc	ra,0xfffff
    80002b34:	7ac080e7          	jalr	1964(ra) # 800022dc <bread>
    80002b38:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b3a:	05850593          	addi	a1,a0,88
    80002b3e:	40dc                	lw	a5,4(s1)
    80002b40:	8bbd                	andi	a5,a5,15
    80002b42:	079a                	slli	a5,a5,0x6
    80002b44:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b46:	00059783          	lh	a5,0(a1)
    80002b4a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b4e:	00259783          	lh	a5,2(a1)
    80002b52:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b56:	00459783          	lh	a5,4(a1)
    80002b5a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b5e:	00659783          	lh	a5,6(a1)
    80002b62:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b66:	459c                	lw	a5,8(a1)
    80002b68:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b6a:	03400613          	li	a2,52
    80002b6e:	05b1                	addi	a1,a1,12
    80002b70:	05048513          	addi	a0,s1,80
    80002b74:	ffffd097          	auipc	ra,0xffffd
    80002b78:	662080e7          	jalr	1634(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	00000097          	auipc	ra,0x0
    80002b82:	88e080e7          	jalr	-1906(ra) # 8000240c <brelse>
    ip->valid = 1;
    80002b86:	4785                	li	a5,1
    80002b88:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b8a:	04449783          	lh	a5,68(s1)
    80002b8e:	fbb5                	bnez	a5,80002b02 <ilock+0x24>
      panic("ilock: no type");
    80002b90:	00006517          	auipc	a0,0x6
    80002b94:	a9050513          	addi	a0,a0,-1392 # 80008620 <syscalls+0x190>
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	fb8080e7          	jalr	-72(ra) # 80005b50 <panic>

0000000080002ba0 <iunlock>:
{
    80002ba0:	1101                	addi	sp,sp,-32
    80002ba2:	ec06                	sd	ra,24(sp)
    80002ba4:	e822                	sd	s0,16(sp)
    80002ba6:	e426                	sd	s1,8(sp)
    80002ba8:	e04a                	sd	s2,0(sp)
    80002baa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bac:	c905                	beqz	a0,80002bdc <iunlock+0x3c>
    80002bae:	84aa                	mv	s1,a0
    80002bb0:	01050913          	addi	s2,a0,16
    80002bb4:	854a                	mv	a0,s2
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	c92080e7          	jalr	-878(ra) # 80003848 <holdingsleep>
    80002bbe:	cd19                	beqz	a0,80002bdc <iunlock+0x3c>
    80002bc0:	449c                	lw	a5,8(s1)
    80002bc2:	00f05d63          	blez	a5,80002bdc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00001097          	auipc	ra,0x1
    80002bcc:	c3c080e7          	jalr	-964(ra) # 80003804 <releasesleep>
}
    80002bd0:	60e2                	ld	ra,24(sp)
    80002bd2:	6442                	ld	s0,16(sp)
    80002bd4:	64a2                	ld	s1,8(sp)
    80002bd6:	6902                	ld	s2,0(sp)
    80002bd8:	6105                	addi	sp,sp,32
    80002bda:	8082                	ret
    panic("iunlock");
    80002bdc:	00006517          	auipc	a0,0x6
    80002be0:	a5450513          	addi	a0,a0,-1452 # 80008630 <syscalls+0x1a0>
    80002be4:	00003097          	auipc	ra,0x3
    80002be8:	f6c080e7          	jalr	-148(ra) # 80005b50 <panic>

0000000080002bec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bec:	7179                	addi	sp,sp,-48
    80002bee:	f406                	sd	ra,40(sp)
    80002bf0:	f022                	sd	s0,32(sp)
    80002bf2:	ec26                	sd	s1,24(sp)
    80002bf4:	e84a                	sd	s2,16(sp)
    80002bf6:	e44e                	sd	s3,8(sp)
    80002bf8:	e052                	sd	s4,0(sp)
    80002bfa:	1800                	addi	s0,sp,48
    80002bfc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bfe:	05050493          	addi	s1,a0,80
    80002c02:	08050913          	addi	s2,a0,128
    80002c06:	a021                	j	80002c0e <itrunc+0x22>
    80002c08:	0491                	addi	s1,s1,4
    80002c0a:	01248d63          	beq	s1,s2,80002c24 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c0e:	408c                	lw	a1,0(s1)
    80002c10:	dde5                	beqz	a1,80002c08 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c12:	0009a503          	lw	a0,0(s3)
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	90c080e7          	jalr	-1780(ra) # 80002522 <bfree>
      ip->addrs[i] = 0;
    80002c1e:	0004a023          	sw	zero,0(s1)
    80002c22:	b7dd                	j	80002c08 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c24:	0809a583          	lw	a1,128(s3)
    80002c28:	e185                	bnez	a1,80002c48 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c2a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c2e:	854e                	mv	a0,s3
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	de2080e7          	jalr	-542(ra) # 80002a12 <iupdate>
}
    80002c38:	70a2                	ld	ra,40(sp)
    80002c3a:	7402                	ld	s0,32(sp)
    80002c3c:	64e2                	ld	s1,24(sp)
    80002c3e:	6942                	ld	s2,16(sp)
    80002c40:	69a2                	ld	s3,8(sp)
    80002c42:	6a02                	ld	s4,0(sp)
    80002c44:	6145                	addi	sp,sp,48
    80002c46:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c48:	0009a503          	lw	a0,0(s3)
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	690080e7          	jalr	1680(ra) # 800022dc <bread>
    80002c54:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c56:	05850493          	addi	s1,a0,88
    80002c5a:	45850913          	addi	s2,a0,1112
    80002c5e:	a021                	j	80002c66 <itrunc+0x7a>
    80002c60:	0491                	addi	s1,s1,4
    80002c62:	01248b63          	beq	s1,s2,80002c78 <itrunc+0x8c>
      if(a[j])
    80002c66:	408c                	lw	a1,0(s1)
    80002c68:	dde5                	beqz	a1,80002c60 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c6a:	0009a503          	lw	a0,0(s3)
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	8b4080e7          	jalr	-1868(ra) # 80002522 <bfree>
    80002c76:	b7ed                	j	80002c60 <itrunc+0x74>
    brelse(bp);
    80002c78:	8552                	mv	a0,s4
    80002c7a:	fffff097          	auipc	ra,0xfffff
    80002c7e:	792080e7          	jalr	1938(ra) # 8000240c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c82:	0809a583          	lw	a1,128(s3)
    80002c86:	0009a503          	lw	a0,0(s3)
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	898080e7          	jalr	-1896(ra) # 80002522 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c92:	0809a023          	sw	zero,128(s3)
    80002c96:	bf51                	j	80002c2a <itrunc+0x3e>

0000000080002c98 <iput>:
{
    80002c98:	1101                	addi	sp,sp,-32
    80002c9a:	ec06                	sd	ra,24(sp)
    80002c9c:	e822                	sd	s0,16(sp)
    80002c9e:	e426                	sd	s1,8(sp)
    80002ca0:	e04a                	sd	s2,0(sp)
    80002ca2:	1000                	addi	s0,sp,32
    80002ca4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca6:	00015517          	auipc	a0,0x15
    80002caa:	8d250513          	addi	a0,a0,-1838 # 80017578 <itable>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	3da080e7          	jalr	986(ra) # 80006088 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb6:	4498                	lw	a4,8(s1)
    80002cb8:	4785                	li	a5,1
    80002cba:	02f70363          	beq	a4,a5,80002ce0 <iput+0x48>
  ip->ref--;
    80002cbe:	449c                	lw	a5,8(s1)
    80002cc0:	37fd                	addiw	a5,a5,-1
    80002cc2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cc4:	00015517          	auipc	a0,0x15
    80002cc8:	8b450513          	addi	a0,a0,-1868 # 80017578 <itable>
    80002ccc:	00003097          	auipc	ra,0x3
    80002cd0:	470080e7          	jalr	1136(ra) # 8000613c <release>
}
    80002cd4:	60e2                	ld	ra,24(sp)
    80002cd6:	6442                	ld	s0,16(sp)
    80002cd8:	64a2                	ld	s1,8(sp)
    80002cda:	6902                	ld	s2,0(sp)
    80002cdc:	6105                	addi	sp,sp,32
    80002cde:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ce0:	40bc                	lw	a5,64(s1)
    80002ce2:	dff1                	beqz	a5,80002cbe <iput+0x26>
    80002ce4:	04a49783          	lh	a5,74(s1)
    80002ce8:	fbf9                	bnez	a5,80002cbe <iput+0x26>
    acquiresleep(&ip->lock);
    80002cea:	01048913          	addi	s2,s1,16
    80002cee:	854a                	mv	a0,s2
    80002cf0:	00001097          	auipc	ra,0x1
    80002cf4:	abe080e7          	jalr	-1346(ra) # 800037ae <acquiresleep>
    release(&itable.lock);
    80002cf8:	00015517          	auipc	a0,0x15
    80002cfc:	88050513          	addi	a0,a0,-1920 # 80017578 <itable>
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	43c080e7          	jalr	1084(ra) # 8000613c <release>
    itrunc(ip);
    80002d08:	8526                	mv	a0,s1
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	ee2080e7          	jalr	-286(ra) # 80002bec <itrunc>
    ip->type = 0;
    80002d12:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d16:	8526                	mv	a0,s1
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	cfa080e7          	jalr	-774(ra) # 80002a12 <iupdate>
    ip->valid = 0;
    80002d20:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d24:	854a                	mv	a0,s2
    80002d26:	00001097          	auipc	ra,0x1
    80002d2a:	ade080e7          	jalr	-1314(ra) # 80003804 <releasesleep>
    acquire(&itable.lock);
    80002d2e:	00015517          	auipc	a0,0x15
    80002d32:	84a50513          	addi	a0,a0,-1974 # 80017578 <itable>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	352080e7          	jalr	850(ra) # 80006088 <acquire>
    80002d3e:	b741                	j	80002cbe <iput+0x26>

0000000080002d40 <iunlockput>:
{
    80002d40:	1101                	addi	sp,sp,-32
    80002d42:	ec06                	sd	ra,24(sp)
    80002d44:	e822                	sd	s0,16(sp)
    80002d46:	e426                	sd	s1,8(sp)
    80002d48:	1000                	addi	s0,sp,32
    80002d4a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	e54080e7          	jalr	-428(ra) # 80002ba0 <iunlock>
  iput(ip);
    80002d54:	8526                	mv	a0,s1
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	f42080e7          	jalr	-190(ra) # 80002c98 <iput>
}
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret

0000000080002d68 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d68:	1141                	addi	sp,sp,-16
    80002d6a:	e422                	sd	s0,8(sp)
    80002d6c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d6e:	411c                	lw	a5,0(a0)
    80002d70:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d72:	415c                	lw	a5,4(a0)
    80002d74:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d76:	04451783          	lh	a5,68(a0)
    80002d7a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d7e:	04a51783          	lh	a5,74(a0)
    80002d82:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d86:	04c56783          	lwu	a5,76(a0)
    80002d8a:	e99c                	sd	a5,16(a1)
}
    80002d8c:	6422                	ld	s0,8(sp)
    80002d8e:	0141                	addi	sp,sp,16
    80002d90:	8082                	ret

0000000080002d92 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d92:	457c                	lw	a5,76(a0)
    80002d94:	0ed7e963          	bltu	a5,a3,80002e86 <readi+0xf4>
{
    80002d98:	7159                	addi	sp,sp,-112
    80002d9a:	f486                	sd	ra,104(sp)
    80002d9c:	f0a2                	sd	s0,96(sp)
    80002d9e:	eca6                	sd	s1,88(sp)
    80002da0:	e8ca                	sd	s2,80(sp)
    80002da2:	e4ce                	sd	s3,72(sp)
    80002da4:	e0d2                	sd	s4,64(sp)
    80002da6:	fc56                	sd	s5,56(sp)
    80002da8:	f85a                	sd	s6,48(sp)
    80002daa:	f45e                	sd	s7,40(sp)
    80002dac:	f062                	sd	s8,32(sp)
    80002dae:	ec66                	sd	s9,24(sp)
    80002db0:	e86a                	sd	s10,16(sp)
    80002db2:	e46e                	sd	s11,8(sp)
    80002db4:	1880                	addi	s0,sp,112
    80002db6:	8baa                	mv	s7,a0
    80002db8:	8c2e                	mv	s8,a1
    80002dba:	8ab2                	mv	s5,a2
    80002dbc:	84b6                	mv	s1,a3
    80002dbe:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dc0:	9f35                	addw	a4,a4,a3
    return 0;
    80002dc2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dc4:	0ad76063          	bltu	a4,a3,80002e64 <readi+0xd2>
  if(off + n > ip->size)
    80002dc8:	00e7f463          	bgeu	a5,a4,80002dd0 <readi+0x3e>
    n = ip->size - off;
    80002dcc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dd0:	0a0b0963          	beqz	s6,80002e82 <readi+0xf0>
    80002dd4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dd6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dda:	5cfd                	li	s9,-1
    80002ddc:	a82d                	j	80002e16 <readi+0x84>
    80002dde:	020a1d93          	slli	s11,s4,0x20
    80002de2:	020ddd93          	srli	s11,s11,0x20
    80002de6:	05890613          	addi	a2,s2,88
    80002dea:	86ee                	mv	a3,s11
    80002dec:	963a                	add	a2,a2,a4
    80002dee:	85d6                	mv	a1,s5
    80002df0:	8562                	mv	a0,s8
    80002df2:	fffff097          	auipc	ra,0xfffff
    80002df6:	ac2080e7          	jalr	-1342(ra) # 800018b4 <either_copyout>
    80002dfa:	05950d63          	beq	a0,s9,80002e54 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dfe:	854a                	mv	a0,s2
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	60c080e7          	jalr	1548(ra) # 8000240c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e08:	013a09bb          	addw	s3,s4,s3
    80002e0c:	009a04bb          	addw	s1,s4,s1
    80002e10:	9aee                	add	s5,s5,s11
    80002e12:	0569f763          	bgeu	s3,s6,80002e60 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e16:	000ba903          	lw	s2,0(s7)
    80002e1a:	00a4d59b          	srliw	a1,s1,0xa
    80002e1e:	855e                	mv	a0,s7
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	8ac080e7          	jalr	-1876(ra) # 800026cc <bmap>
    80002e28:	0005059b          	sext.w	a1,a0
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	fffff097          	auipc	ra,0xfffff
    80002e32:	4ae080e7          	jalr	1198(ra) # 800022dc <bread>
    80002e36:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e38:	3ff4f713          	andi	a4,s1,1023
    80002e3c:	40ed07bb          	subw	a5,s10,a4
    80002e40:	413b06bb          	subw	a3,s6,s3
    80002e44:	8a3e                	mv	s4,a5
    80002e46:	2781                	sext.w	a5,a5
    80002e48:	0006861b          	sext.w	a2,a3
    80002e4c:	f8f679e3          	bgeu	a2,a5,80002dde <readi+0x4c>
    80002e50:	8a36                	mv	s4,a3
    80002e52:	b771                	j	80002dde <readi+0x4c>
      brelse(bp);
    80002e54:	854a                	mv	a0,s2
    80002e56:	fffff097          	auipc	ra,0xfffff
    80002e5a:	5b6080e7          	jalr	1462(ra) # 8000240c <brelse>
      tot = -1;
    80002e5e:	59fd                	li	s3,-1
  }
  return tot;
    80002e60:	0009851b          	sext.w	a0,s3
}
    80002e64:	70a6                	ld	ra,104(sp)
    80002e66:	7406                	ld	s0,96(sp)
    80002e68:	64e6                	ld	s1,88(sp)
    80002e6a:	6946                	ld	s2,80(sp)
    80002e6c:	69a6                	ld	s3,72(sp)
    80002e6e:	6a06                	ld	s4,64(sp)
    80002e70:	7ae2                	ld	s5,56(sp)
    80002e72:	7b42                	ld	s6,48(sp)
    80002e74:	7ba2                	ld	s7,40(sp)
    80002e76:	7c02                	ld	s8,32(sp)
    80002e78:	6ce2                	ld	s9,24(sp)
    80002e7a:	6d42                	ld	s10,16(sp)
    80002e7c:	6da2                	ld	s11,8(sp)
    80002e7e:	6165                	addi	sp,sp,112
    80002e80:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e82:	89da                	mv	s3,s6
    80002e84:	bff1                	j	80002e60 <readi+0xce>
    return 0;
    80002e86:	4501                	li	a0,0
}
    80002e88:	8082                	ret

0000000080002e8a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8a:	457c                	lw	a5,76(a0)
    80002e8c:	10d7e863          	bltu	a5,a3,80002f9c <writei+0x112>
{
    80002e90:	7159                	addi	sp,sp,-112
    80002e92:	f486                	sd	ra,104(sp)
    80002e94:	f0a2                	sd	s0,96(sp)
    80002e96:	eca6                	sd	s1,88(sp)
    80002e98:	e8ca                	sd	s2,80(sp)
    80002e9a:	e4ce                	sd	s3,72(sp)
    80002e9c:	e0d2                	sd	s4,64(sp)
    80002e9e:	fc56                	sd	s5,56(sp)
    80002ea0:	f85a                	sd	s6,48(sp)
    80002ea2:	f45e                	sd	s7,40(sp)
    80002ea4:	f062                	sd	s8,32(sp)
    80002ea6:	ec66                	sd	s9,24(sp)
    80002ea8:	e86a                	sd	s10,16(sp)
    80002eaa:	e46e                	sd	s11,8(sp)
    80002eac:	1880                	addi	s0,sp,112
    80002eae:	8b2a                	mv	s6,a0
    80002eb0:	8c2e                	mv	s8,a1
    80002eb2:	8ab2                	mv	s5,a2
    80002eb4:	8936                	mv	s2,a3
    80002eb6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002eb8:	00e687bb          	addw	a5,a3,a4
    80002ebc:	0ed7e263          	bltu	a5,a3,80002fa0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ec0:	00043737          	lui	a4,0x43
    80002ec4:	0ef76063          	bltu	a4,a5,80002fa4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ec8:	0c0b8863          	beqz	s7,80002f98 <writei+0x10e>
    80002ecc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ece:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed2:	5cfd                	li	s9,-1
    80002ed4:	a091                	j	80002f18 <writei+0x8e>
    80002ed6:	02099d93          	slli	s11,s3,0x20
    80002eda:	020ddd93          	srli	s11,s11,0x20
    80002ede:	05848513          	addi	a0,s1,88
    80002ee2:	86ee                	mv	a3,s11
    80002ee4:	8656                	mv	a2,s5
    80002ee6:	85e2                	mv	a1,s8
    80002ee8:	953a                	add	a0,a0,a4
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	a20080e7          	jalr	-1504(ra) # 8000190a <either_copyin>
    80002ef2:	07950263          	beq	a0,s9,80002f56 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ef6:	8526                	mv	a0,s1
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	798080e7          	jalr	1944(ra) # 80003690 <log_write>
    brelse(bp);
    80002f00:	8526                	mv	a0,s1
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	50a080e7          	jalr	1290(ra) # 8000240c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0a:	01498a3b          	addw	s4,s3,s4
    80002f0e:	0129893b          	addw	s2,s3,s2
    80002f12:	9aee                	add	s5,s5,s11
    80002f14:	057a7663          	bgeu	s4,s7,80002f60 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f18:	000b2483          	lw	s1,0(s6)
    80002f1c:	00a9559b          	srliw	a1,s2,0xa
    80002f20:	855a                	mv	a0,s6
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	7aa080e7          	jalr	1962(ra) # 800026cc <bmap>
    80002f2a:	0005059b          	sext.w	a1,a0
    80002f2e:	8526                	mv	a0,s1
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	3ac080e7          	jalr	940(ra) # 800022dc <bread>
    80002f38:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3a:	3ff97713          	andi	a4,s2,1023
    80002f3e:	40ed07bb          	subw	a5,s10,a4
    80002f42:	414b86bb          	subw	a3,s7,s4
    80002f46:	89be                	mv	s3,a5
    80002f48:	2781                	sext.w	a5,a5
    80002f4a:	0006861b          	sext.w	a2,a3
    80002f4e:	f8f674e3          	bgeu	a2,a5,80002ed6 <writei+0x4c>
    80002f52:	89b6                	mv	s3,a3
    80002f54:	b749                	j	80002ed6 <writei+0x4c>
      brelse(bp);
    80002f56:	8526                	mv	a0,s1
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	4b4080e7          	jalr	1204(ra) # 8000240c <brelse>
  }

  if(off > ip->size)
    80002f60:	04cb2783          	lw	a5,76(s6)
    80002f64:	0127f463          	bgeu	a5,s2,80002f6c <writei+0xe2>
    ip->size = off;
    80002f68:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f6c:	855a                	mv	a0,s6
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	aa4080e7          	jalr	-1372(ra) # 80002a12 <iupdate>

  return tot;
    80002f76:	000a051b          	sext.w	a0,s4
}
    80002f7a:	70a6                	ld	ra,104(sp)
    80002f7c:	7406                	ld	s0,96(sp)
    80002f7e:	64e6                	ld	s1,88(sp)
    80002f80:	6946                	ld	s2,80(sp)
    80002f82:	69a6                	ld	s3,72(sp)
    80002f84:	6a06                	ld	s4,64(sp)
    80002f86:	7ae2                	ld	s5,56(sp)
    80002f88:	7b42                	ld	s6,48(sp)
    80002f8a:	7ba2                	ld	s7,40(sp)
    80002f8c:	7c02                	ld	s8,32(sp)
    80002f8e:	6ce2                	ld	s9,24(sp)
    80002f90:	6d42                	ld	s10,16(sp)
    80002f92:	6da2                	ld	s11,8(sp)
    80002f94:	6165                	addi	sp,sp,112
    80002f96:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f98:	8a5e                	mv	s4,s7
    80002f9a:	bfc9                	j	80002f6c <writei+0xe2>
    return -1;
    80002f9c:	557d                	li	a0,-1
}
    80002f9e:	8082                	ret
    return -1;
    80002fa0:	557d                	li	a0,-1
    80002fa2:	bfe1                	j	80002f7a <writei+0xf0>
    return -1;
    80002fa4:	557d                	li	a0,-1
    80002fa6:	bfd1                	j	80002f7a <writei+0xf0>

0000000080002fa8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fa8:	1141                	addi	sp,sp,-16
    80002faa:	e406                	sd	ra,8(sp)
    80002fac:	e022                	sd	s0,0(sp)
    80002fae:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fb0:	4639                	li	a2,14
    80002fb2:	ffffd097          	auipc	ra,0xffffd
    80002fb6:	298080e7          	jalr	664(ra) # 8000024a <strncmp>
}
    80002fba:	60a2                	ld	ra,8(sp)
    80002fbc:	6402                	ld	s0,0(sp)
    80002fbe:	0141                	addi	sp,sp,16
    80002fc0:	8082                	ret

0000000080002fc2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fc2:	7139                	addi	sp,sp,-64
    80002fc4:	fc06                	sd	ra,56(sp)
    80002fc6:	f822                	sd	s0,48(sp)
    80002fc8:	f426                	sd	s1,40(sp)
    80002fca:	f04a                	sd	s2,32(sp)
    80002fcc:	ec4e                	sd	s3,24(sp)
    80002fce:	e852                	sd	s4,16(sp)
    80002fd0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fd2:	04451703          	lh	a4,68(a0)
    80002fd6:	4785                	li	a5,1
    80002fd8:	00f71a63          	bne	a4,a5,80002fec <dirlookup+0x2a>
    80002fdc:	892a                	mv	s2,a0
    80002fde:	89ae                	mv	s3,a1
    80002fe0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe2:	457c                	lw	a5,76(a0)
    80002fe4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fe6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe8:	e79d                	bnez	a5,80003016 <dirlookup+0x54>
    80002fea:	a8a5                	j	80003062 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fec:	00005517          	auipc	a0,0x5
    80002ff0:	64c50513          	addi	a0,a0,1612 # 80008638 <syscalls+0x1a8>
    80002ff4:	00003097          	auipc	ra,0x3
    80002ff8:	b5c080e7          	jalr	-1188(ra) # 80005b50 <panic>
      panic("dirlookup read");
    80002ffc:	00005517          	auipc	a0,0x5
    80003000:	65450513          	addi	a0,a0,1620 # 80008650 <syscalls+0x1c0>
    80003004:	00003097          	auipc	ra,0x3
    80003008:	b4c080e7          	jalr	-1204(ra) # 80005b50 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000300c:	24c1                	addiw	s1,s1,16
    8000300e:	04c92783          	lw	a5,76(s2)
    80003012:	04f4f763          	bgeu	s1,a5,80003060 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003016:	4741                	li	a4,16
    80003018:	86a6                	mv	a3,s1
    8000301a:	fc040613          	addi	a2,s0,-64
    8000301e:	4581                	li	a1,0
    80003020:	854a                	mv	a0,s2
    80003022:	00000097          	auipc	ra,0x0
    80003026:	d70080e7          	jalr	-656(ra) # 80002d92 <readi>
    8000302a:	47c1                	li	a5,16
    8000302c:	fcf518e3          	bne	a0,a5,80002ffc <dirlookup+0x3a>
    if(de.inum == 0)
    80003030:	fc045783          	lhu	a5,-64(s0)
    80003034:	dfe1                	beqz	a5,8000300c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003036:	fc240593          	addi	a1,s0,-62
    8000303a:	854e                	mv	a0,s3
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	f6c080e7          	jalr	-148(ra) # 80002fa8 <namecmp>
    80003044:	f561                	bnez	a0,8000300c <dirlookup+0x4a>
      if(poff)
    80003046:	000a0463          	beqz	s4,8000304e <dirlookup+0x8c>
        *poff = off;
    8000304a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000304e:	fc045583          	lhu	a1,-64(s0)
    80003052:	00092503          	lw	a0,0(s2)
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	752080e7          	jalr	1874(ra) # 800027a8 <iget>
    8000305e:	a011                	j	80003062 <dirlookup+0xa0>
  return 0;
    80003060:	4501                	li	a0,0
}
    80003062:	70e2                	ld	ra,56(sp)
    80003064:	7442                	ld	s0,48(sp)
    80003066:	74a2                	ld	s1,40(sp)
    80003068:	7902                	ld	s2,32(sp)
    8000306a:	69e2                	ld	s3,24(sp)
    8000306c:	6a42                	ld	s4,16(sp)
    8000306e:	6121                	addi	sp,sp,64
    80003070:	8082                	ret

0000000080003072 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003072:	711d                	addi	sp,sp,-96
    80003074:	ec86                	sd	ra,88(sp)
    80003076:	e8a2                	sd	s0,80(sp)
    80003078:	e4a6                	sd	s1,72(sp)
    8000307a:	e0ca                	sd	s2,64(sp)
    8000307c:	fc4e                	sd	s3,56(sp)
    8000307e:	f852                	sd	s4,48(sp)
    80003080:	f456                	sd	s5,40(sp)
    80003082:	f05a                	sd	s6,32(sp)
    80003084:	ec5e                	sd	s7,24(sp)
    80003086:	e862                	sd	s8,16(sp)
    80003088:	e466                	sd	s9,8(sp)
    8000308a:	e06a                	sd	s10,0(sp)
    8000308c:	1080                	addi	s0,sp,96
    8000308e:	84aa                	mv	s1,a0
    80003090:	8b2e                	mv	s6,a1
    80003092:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003094:	00054703          	lbu	a4,0(a0)
    80003098:	02f00793          	li	a5,47
    8000309c:	02f70363          	beq	a4,a5,800030c2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	da4080e7          	jalr	-604(ra) # 80000e44 <myproc>
    800030a8:	15053503          	ld	a0,336(a0)
    800030ac:	00000097          	auipc	ra,0x0
    800030b0:	9f4080e7          	jalr	-1548(ra) # 80002aa0 <idup>
    800030b4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030b6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030ba:	4cb5                	li	s9,13
  len = path - s;
    800030bc:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030be:	4c05                	li	s8,1
    800030c0:	a87d                	j	8000317e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030c2:	4585                	li	a1,1
    800030c4:	4505                	li	a0,1
    800030c6:	fffff097          	auipc	ra,0xfffff
    800030ca:	6e2080e7          	jalr	1762(ra) # 800027a8 <iget>
    800030ce:	8a2a                	mv	s4,a0
    800030d0:	b7dd                	j	800030b6 <namex+0x44>
      iunlockput(ip);
    800030d2:	8552                	mv	a0,s4
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	c6c080e7          	jalr	-916(ra) # 80002d40 <iunlockput>
      return 0;
    800030dc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030de:	8552                	mv	a0,s4
    800030e0:	60e6                	ld	ra,88(sp)
    800030e2:	6446                	ld	s0,80(sp)
    800030e4:	64a6                	ld	s1,72(sp)
    800030e6:	6906                	ld	s2,64(sp)
    800030e8:	79e2                	ld	s3,56(sp)
    800030ea:	7a42                	ld	s4,48(sp)
    800030ec:	7aa2                	ld	s5,40(sp)
    800030ee:	7b02                	ld	s6,32(sp)
    800030f0:	6be2                	ld	s7,24(sp)
    800030f2:	6c42                	ld	s8,16(sp)
    800030f4:	6ca2                	ld	s9,8(sp)
    800030f6:	6d02                	ld	s10,0(sp)
    800030f8:	6125                	addi	sp,sp,96
    800030fa:	8082                	ret
      iunlock(ip);
    800030fc:	8552                	mv	a0,s4
    800030fe:	00000097          	auipc	ra,0x0
    80003102:	aa2080e7          	jalr	-1374(ra) # 80002ba0 <iunlock>
      return ip;
    80003106:	bfe1                	j	800030de <namex+0x6c>
      iunlockput(ip);
    80003108:	8552                	mv	a0,s4
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	c36080e7          	jalr	-970(ra) # 80002d40 <iunlockput>
      return 0;
    80003112:	8a4e                	mv	s4,s3
    80003114:	b7e9                	j	800030de <namex+0x6c>
  len = path - s;
    80003116:	40998633          	sub	a2,s3,s1
    8000311a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000311e:	09acd863          	bge	s9,s10,800031ae <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003122:	4639                	li	a2,14
    80003124:	85a6                	mv	a1,s1
    80003126:	8556                	mv	a0,s5
    80003128:	ffffd097          	auipc	ra,0xffffd
    8000312c:	0ae080e7          	jalr	174(ra) # 800001d6 <memmove>
    80003130:	84ce                	mv	s1,s3
  while(*path == '/')
    80003132:	0004c783          	lbu	a5,0(s1)
    80003136:	01279763          	bne	a5,s2,80003144 <namex+0xd2>
    path++;
    8000313a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000313c:	0004c783          	lbu	a5,0(s1)
    80003140:	ff278de3          	beq	a5,s2,8000313a <namex+0xc8>
    ilock(ip);
    80003144:	8552                	mv	a0,s4
    80003146:	00000097          	auipc	ra,0x0
    8000314a:	998080e7          	jalr	-1640(ra) # 80002ade <ilock>
    if(ip->type != T_DIR){
    8000314e:	044a1783          	lh	a5,68(s4)
    80003152:	f98790e3          	bne	a5,s8,800030d2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003156:	000b0563          	beqz	s6,80003160 <namex+0xee>
    8000315a:	0004c783          	lbu	a5,0(s1)
    8000315e:	dfd9                	beqz	a5,800030fc <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003160:	865e                	mv	a2,s7
    80003162:	85d6                	mv	a1,s5
    80003164:	8552                	mv	a0,s4
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	e5c080e7          	jalr	-420(ra) # 80002fc2 <dirlookup>
    8000316e:	89aa                	mv	s3,a0
    80003170:	dd41                	beqz	a0,80003108 <namex+0x96>
    iunlockput(ip);
    80003172:	8552                	mv	a0,s4
    80003174:	00000097          	auipc	ra,0x0
    80003178:	bcc080e7          	jalr	-1076(ra) # 80002d40 <iunlockput>
    ip = next;
    8000317c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000317e:	0004c783          	lbu	a5,0(s1)
    80003182:	01279763          	bne	a5,s2,80003190 <namex+0x11e>
    path++;
    80003186:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003188:	0004c783          	lbu	a5,0(s1)
    8000318c:	ff278de3          	beq	a5,s2,80003186 <namex+0x114>
  if(*path == 0)
    80003190:	cb9d                	beqz	a5,800031c6 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003192:	0004c783          	lbu	a5,0(s1)
    80003196:	89a6                	mv	s3,s1
  len = path - s;
    80003198:	8d5e                	mv	s10,s7
    8000319a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000319c:	01278963          	beq	a5,s2,800031ae <namex+0x13c>
    800031a0:	dbbd                	beqz	a5,80003116 <namex+0xa4>
    path++;
    800031a2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031a4:	0009c783          	lbu	a5,0(s3)
    800031a8:	ff279ce3          	bne	a5,s2,800031a0 <namex+0x12e>
    800031ac:	b7ad                	j	80003116 <namex+0xa4>
    memmove(name, s, len);
    800031ae:	2601                	sext.w	a2,a2
    800031b0:	85a6                	mv	a1,s1
    800031b2:	8556                	mv	a0,s5
    800031b4:	ffffd097          	auipc	ra,0xffffd
    800031b8:	022080e7          	jalr	34(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031bc:	9d56                	add	s10,s10,s5
    800031be:	000d0023          	sb	zero,0(s10)
    800031c2:	84ce                	mv	s1,s3
    800031c4:	b7bd                	j	80003132 <namex+0xc0>
  if(nameiparent){
    800031c6:	f00b0ce3          	beqz	s6,800030de <namex+0x6c>
    iput(ip);
    800031ca:	8552                	mv	a0,s4
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	acc080e7          	jalr	-1332(ra) # 80002c98 <iput>
    return 0;
    800031d4:	4a01                	li	s4,0
    800031d6:	b721                	j	800030de <namex+0x6c>

00000000800031d8 <dirlink>:
{
    800031d8:	7139                	addi	sp,sp,-64
    800031da:	fc06                	sd	ra,56(sp)
    800031dc:	f822                	sd	s0,48(sp)
    800031de:	f426                	sd	s1,40(sp)
    800031e0:	f04a                	sd	s2,32(sp)
    800031e2:	ec4e                	sd	s3,24(sp)
    800031e4:	e852                	sd	s4,16(sp)
    800031e6:	0080                	addi	s0,sp,64
    800031e8:	892a                	mv	s2,a0
    800031ea:	8a2e                	mv	s4,a1
    800031ec:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031ee:	4601                	li	a2,0
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	dd2080e7          	jalr	-558(ra) # 80002fc2 <dirlookup>
    800031f8:	e93d                	bnez	a0,8000326e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031fa:	04c92483          	lw	s1,76(s2)
    800031fe:	c49d                	beqz	s1,8000322c <dirlink+0x54>
    80003200:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003202:	4741                	li	a4,16
    80003204:	86a6                	mv	a3,s1
    80003206:	fc040613          	addi	a2,s0,-64
    8000320a:	4581                	li	a1,0
    8000320c:	854a                	mv	a0,s2
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	b84080e7          	jalr	-1148(ra) # 80002d92 <readi>
    80003216:	47c1                	li	a5,16
    80003218:	06f51163          	bne	a0,a5,8000327a <dirlink+0xa2>
    if(de.inum == 0)
    8000321c:	fc045783          	lhu	a5,-64(s0)
    80003220:	c791                	beqz	a5,8000322c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003222:	24c1                	addiw	s1,s1,16
    80003224:	04c92783          	lw	a5,76(s2)
    80003228:	fcf4ede3          	bltu	s1,a5,80003202 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000322c:	4639                	li	a2,14
    8000322e:	85d2                	mv	a1,s4
    80003230:	fc240513          	addi	a0,s0,-62
    80003234:	ffffd097          	auipc	ra,0xffffd
    80003238:	052080e7          	jalr	82(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000323c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003240:	4741                	li	a4,16
    80003242:	86a6                	mv	a3,s1
    80003244:	fc040613          	addi	a2,s0,-64
    80003248:	4581                	li	a1,0
    8000324a:	854a                	mv	a0,s2
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	c3e080e7          	jalr	-962(ra) # 80002e8a <writei>
    80003254:	872a                	mv	a4,a0
    80003256:	47c1                	li	a5,16
  return 0;
    80003258:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325a:	02f71863          	bne	a4,a5,8000328a <dirlink+0xb2>
}
    8000325e:	70e2                	ld	ra,56(sp)
    80003260:	7442                	ld	s0,48(sp)
    80003262:	74a2                	ld	s1,40(sp)
    80003264:	7902                	ld	s2,32(sp)
    80003266:	69e2                	ld	s3,24(sp)
    80003268:	6a42                	ld	s4,16(sp)
    8000326a:	6121                	addi	sp,sp,64
    8000326c:	8082                	ret
    iput(ip);
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	a2a080e7          	jalr	-1494(ra) # 80002c98 <iput>
    return -1;
    80003276:	557d                	li	a0,-1
    80003278:	b7dd                	j	8000325e <dirlink+0x86>
      panic("dirlink read");
    8000327a:	00005517          	auipc	a0,0x5
    8000327e:	3e650513          	addi	a0,a0,998 # 80008660 <syscalls+0x1d0>
    80003282:	00003097          	auipc	ra,0x3
    80003286:	8ce080e7          	jalr	-1842(ra) # 80005b50 <panic>
    panic("dirlink");
    8000328a:	00005517          	auipc	a0,0x5
    8000328e:	4de50513          	addi	a0,a0,1246 # 80008768 <syscalls+0x2d8>
    80003292:	00003097          	auipc	ra,0x3
    80003296:	8be080e7          	jalr	-1858(ra) # 80005b50 <panic>

000000008000329a <namei>:

struct inode*
namei(char *path)
{
    8000329a:	1101                	addi	sp,sp,-32
    8000329c:	ec06                	sd	ra,24(sp)
    8000329e:	e822                	sd	s0,16(sp)
    800032a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032a2:	fe040613          	addi	a2,s0,-32
    800032a6:	4581                	li	a1,0
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	dca080e7          	jalr	-566(ra) # 80003072 <namex>
}
    800032b0:	60e2                	ld	ra,24(sp)
    800032b2:	6442                	ld	s0,16(sp)
    800032b4:	6105                	addi	sp,sp,32
    800032b6:	8082                	ret

00000000800032b8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032b8:	1141                	addi	sp,sp,-16
    800032ba:	e406                	sd	ra,8(sp)
    800032bc:	e022                	sd	s0,0(sp)
    800032be:	0800                	addi	s0,sp,16
    800032c0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032c2:	4585                	li	a1,1
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	dae080e7          	jalr	-594(ra) # 80003072 <namex>
}
    800032cc:	60a2                	ld	ra,8(sp)
    800032ce:	6402                	ld	s0,0(sp)
    800032d0:	0141                	addi	sp,sp,16
    800032d2:	8082                	ret

00000000800032d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032d4:	1101                	addi	sp,sp,-32
    800032d6:	ec06                	sd	ra,24(sp)
    800032d8:	e822                	sd	s0,16(sp)
    800032da:	e426                	sd	s1,8(sp)
    800032dc:	e04a                	sd	s2,0(sp)
    800032de:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032e0:	00016917          	auipc	s2,0x16
    800032e4:	d4090913          	addi	s2,s2,-704 # 80019020 <log>
    800032e8:	01892583          	lw	a1,24(s2)
    800032ec:	02892503          	lw	a0,40(s2)
    800032f0:	fffff097          	auipc	ra,0xfffff
    800032f4:	fec080e7          	jalr	-20(ra) # 800022dc <bread>
    800032f8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032fa:	02c92683          	lw	a3,44(s2)
    800032fe:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003300:	02d05863          	blez	a3,80003330 <write_head+0x5c>
    80003304:	00016797          	auipc	a5,0x16
    80003308:	d4c78793          	addi	a5,a5,-692 # 80019050 <log+0x30>
    8000330c:	05c50713          	addi	a4,a0,92
    80003310:	36fd                	addiw	a3,a3,-1
    80003312:	02069613          	slli	a2,a3,0x20
    80003316:	01e65693          	srli	a3,a2,0x1e
    8000331a:	00016617          	auipc	a2,0x16
    8000331e:	d3a60613          	addi	a2,a2,-710 # 80019054 <log+0x34>
    80003322:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003324:	4390                	lw	a2,0(a5)
    80003326:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003328:	0791                	addi	a5,a5,4
    8000332a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000332c:	fed79ce3          	bne	a5,a3,80003324 <write_head+0x50>
  }
  bwrite(buf);
    80003330:	8526                	mv	a0,s1
    80003332:	fffff097          	auipc	ra,0xfffff
    80003336:	09c080e7          	jalr	156(ra) # 800023ce <bwrite>
  brelse(buf);
    8000333a:	8526                	mv	a0,s1
    8000333c:	fffff097          	auipc	ra,0xfffff
    80003340:	0d0080e7          	jalr	208(ra) # 8000240c <brelse>
}
    80003344:	60e2                	ld	ra,24(sp)
    80003346:	6442                	ld	s0,16(sp)
    80003348:	64a2                	ld	s1,8(sp)
    8000334a:	6902                	ld	s2,0(sp)
    8000334c:	6105                	addi	sp,sp,32
    8000334e:	8082                	ret

0000000080003350 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003350:	00016797          	auipc	a5,0x16
    80003354:	cfc7a783          	lw	a5,-772(a5) # 8001904c <log+0x2c>
    80003358:	0af05d63          	blez	a5,80003412 <install_trans+0xc2>
{
    8000335c:	7139                	addi	sp,sp,-64
    8000335e:	fc06                	sd	ra,56(sp)
    80003360:	f822                	sd	s0,48(sp)
    80003362:	f426                	sd	s1,40(sp)
    80003364:	f04a                	sd	s2,32(sp)
    80003366:	ec4e                	sd	s3,24(sp)
    80003368:	e852                	sd	s4,16(sp)
    8000336a:	e456                	sd	s5,8(sp)
    8000336c:	e05a                	sd	s6,0(sp)
    8000336e:	0080                	addi	s0,sp,64
    80003370:	8b2a                	mv	s6,a0
    80003372:	00016a97          	auipc	s5,0x16
    80003376:	cdea8a93          	addi	s5,s5,-802 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000337a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000337c:	00016997          	auipc	s3,0x16
    80003380:	ca498993          	addi	s3,s3,-860 # 80019020 <log>
    80003384:	a00d                	j	800033a6 <install_trans+0x56>
    brelse(lbuf);
    80003386:	854a                	mv	a0,s2
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	084080e7          	jalr	132(ra) # 8000240c <brelse>
    brelse(dbuf);
    80003390:	8526                	mv	a0,s1
    80003392:	fffff097          	auipc	ra,0xfffff
    80003396:	07a080e7          	jalr	122(ra) # 8000240c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000339a:	2a05                	addiw	s4,s4,1
    8000339c:	0a91                	addi	s5,s5,4
    8000339e:	02c9a783          	lw	a5,44(s3)
    800033a2:	04fa5e63          	bge	s4,a5,800033fe <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a6:	0189a583          	lw	a1,24(s3)
    800033aa:	014585bb          	addw	a1,a1,s4
    800033ae:	2585                	addiw	a1,a1,1
    800033b0:	0289a503          	lw	a0,40(s3)
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	f28080e7          	jalr	-216(ra) # 800022dc <bread>
    800033bc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033be:	000aa583          	lw	a1,0(s5)
    800033c2:	0289a503          	lw	a0,40(s3)
    800033c6:	fffff097          	auipc	ra,0xfffff
    800033ca:	f16080e7          	jalr	-234(ra) # 800022dc <bread>
    800033ce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033d0:	40000613          	li	a2,1024
    800033d4:	05890593          	addi	a1,s2,88
    800033d8:	05850513          	addi	a0,a0,88
    800033dc:	ffffd097          	auipc	ra,0xffffd
    800033e0:	dfa080e7          	jalr	-518(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033e4:	8526                	mv	a0,s1
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	fe8080e7          	jalr	-24(ra) # 800023ce <bwrite>
    if(recovering == 0)
    800033ee:	f80b1ce3          	bnez	s6,80003386 <install_trans+0x36>
      bunpin(dbuf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	0f2080e7          	jalr	242(ra) # 800024e6 <bunpin>
    800033fc:	b769                	j	80003386 <install_trans+0x36>
}
    800033fe:	70e2                	ld	ra,56(sp)
    80003400:	7442                	ld	s0,48(sp)
    80003402:	74a2                	ld	s1,40(sp)
    80003404:	7902                	ld	s2,32(sp)
    80003406:	69e2                	ld	s3,24(sp)
    80003408:	6a42                	ld	s4,16(sp)
    8000340a:	6aa2                	ld	s5,8(sp)
    8000340c:	6b02                	ld	s6,0(sp)
    8000340e:	6121                	addi	sp,sp,64
    80003410:	8082                	ret
    80003412:	8082                	ret

0000000080003414 <initlog>:
{
    80003414:	7179                	addi	sp,sp,-48
    80003416:	f406                	sd	ra,40(sp)
    80003418:	f022                	sd	s0,32(sp)
    8000341a:	ec26                	sd	s1,24(sp)
    8000341c:	e84a                	sd	s2,16(sp)
    8000341e:	e44e                	sd	s3,8(sp)
    80003420:	1800                	addi	s0,sp,48
    80003422:	892a                	mv	s2,a0
    80003424:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003426:	00016497          	auipc	s1,0x16
    8000342a:	bfa48493          	addi	s1,s1,-1030 # 80019020 <log>
    8000342e:	00005597          	auipc	a1,0x5
    80003432:	24258593          	addi	a1,a1,578 # 80008670 <syscalls+0x1e0>
    80003436:	8526                	mv	a0,s1
    80003438:	00003097          	auipc	ra,0x3
    8000343c:	bc0080e7          	jalr	-1088(ra) # 80005ff8 <initlock>
  log.start = sb->logstart;
    80003440:	0149a583          	lw	a1,20(s3)
    80003444:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003446:	0109a783          	lw	a5,16(s3)
    8000344a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000344c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003450:	854a                	mv	a0,s2
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	e8a080e7          	jalr	-374(ra) # 800022dc <bread>
  log.lh.n = lh->n;
    8000345a:	4d34                	lw	a3,88(a0)
    8000345c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000345e:	02d05663          	blez	a3,8000348a <initlog+0x76>
    80003462:	05c50793          	addi	a5,a0,92
    80003466:	00016717          	auipc	a4,0x16
    8000346a:	bea70713          	addi	a4,a4,-1046 # 80019050 <log+0x30>
    8000346e:	36fd                	addiw	a3,a3,-1
    80003470:	02069613          	slli	a2,a3,0x20
    80003474:	01e65693          	srli	a3,a2,0x1e
    80003478:	06050613          	addi	a2,a0,96
    8000347c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000347e:	4390                	lw	a2,0(a5)
    80003480:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003482:	0791                	addi	a5,a5,4
    80003484:	0711                	addi	a4,a4,4
    80003486:	fed79ce3          	bne	a5,a3,8000347e <initlog+0x6a>
  brelse(buf);
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	f82080e7          	jalr	-126(ra) # 8000240c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003492:	4505                	li	a0,1
    80003494:	00000097          	auipc	ra,0x0
    80003498:	ebc080e7          	jalr	-324(ra) # 80003350 <install_trans>
  log.lh.n = 0;
    8000349c:	00016797          	auipc	a5,0x16
    800034a0:	ba07a823          	sw	zero,-1104(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	e30080e7          	jalr	-464(ra) # 800032d4 <write_head>
}
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	6145                	addi	sp,sp,48
    800034b8:	8082                	ret

00000000800034ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034ba:	1101                	addi	sp,sp,-32
    800034bc:	ec06                	sd	ra,24(sp)
    800034be:	e822                	sd	s0,16(sp)
    800034c0:	e426                	sd	s1,8(sp)
    800034c2:	e04a                	sd	s2,0(sp)
    800034c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034c6:	00016517          	auipc	a0,0x16
    800034ca:	b5a50513          	addi	a0,a0,-1190 # 80019020 <log>
    800034ce:	00003097          	auipc	ra,0x3
    800034d2:	bba080e7          	jalr	-1094(ra) # 80006088 <acquire>
  while(1){
    if(log.committing){
    800034d6:	00016497          	auipc	s1,0x16
    800034da:	b4a48493          	addi	s1,s1,-1206 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034de:	4979                	li	s2,30
    800034e0:	a039                	j	800034ee <begin_op+0x34>
      sleep(&log, &log.lock);
    800034e2:	85a6                	mv	a1,s1
    800034e4:	8526                	mv	a0,s1
    800034e6:	ffffe097          	auipc	ra,0xffffe
    800034ea:	02a080e7          	jalr	42(ra) # 80001510 <sleep>
    if(log.committing){
    800034ee:	50dc                	lw	a5,36(s1)
    800034f0:	fbed                	bnez	a5,800034e2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034f2:	5098                	lw	a4,32(s1)
    800034f4:	2705                	addiw	a4,a4,1
    800034f6:	0007069b          	sext.w	a3,a4
    800034fa:	0027179b          	slliw	a5,a4,0x2
    800034fe:	9fb9                	addw	a5,a5,a4
    80003500:	0017979b          	slliw	a5,a5,0x1
    80003504:	54d8                	lw	a4,44(s1)
    80003506:	9fb9                	addw	a5,a5,a4
    80003508:	00f95963          	bge	s2,a5,8000351a <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000350c:	85a6                	mv	a1,s1
    8000350e:	8526                	mv	a0,s1
    80003510:	ffffe097          	auipc	ra,0xffffe
    80003514:	000080e7          	jalr	ra # 80001510 <sleep>
    80003518:	bfd9                	j	800034ee <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000351a:	00016517          	auipc	a0,0x16
    8000351e:	b0650513          	addi	a0,a0,-1274 # 80019020 <log>
    80003522:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003524:	00003097          	auipc	ra,0x3
    80003528:	c18080e7          	jalr	-1000(ra) # 8000613c <release>
      break;
    }
  }
}
    8000352c:	60e2                	ld	ra,24(sp)
    8000352e:	6442                	ld	s0,16(sp)
    80003530:	64a2                	ld	s1,8(sp)
    80003532:	6902                	ld	s2,0(sp)
    80003534:	6105                	addi	sp,sp,32
    80003536:	8082                	ret

0000000080003538 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003538:	7139                	addi	sp,sp,-64
    8000353a:	fc06                	sd	ra,56(sp)
    8000353c:	f822                	sd	s0,48(sp)
    8000353e:	f426                	sd	s1,40(sp)
    80003540:	f04a                	sd	s2,32(sp)
    80003542:	ec4e                	sd	s3,24(sp)
    80003544:	e852                	sd	s4,16(sp)
    80003546:	e456                	sd	s5,8(sp)
    80003548:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000354a:	00016497          	auipc	s1,0x16
    8000354e:	ad648493          	addi	s1,s1,-1322 # 80019020 <log>
    80003552:	8526                	mv	a0,s1
    80003554:	00003097          	auipc	ra,0x3
    80003558:	b34080e7          	jalr	-1228(ra) # 80006088 <acquire>
  log.outstanding -= 1;
    8000355c:	509c                	lw	a5,32(s1)
    8000355e:	37fd                	addiw	a5,a5,-1
    80003560:	0007891b          	sext.w	s2,a5
    80003564:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003566:	50dc                	lw	a5,36(s1)
    80003568:	e7b9                	bnez	a5,800035b6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000356a:	04091e63          	bnez	s2,800035c6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000356e:	00016497          	auipc	s1,0x16
    80003572:	ab248493          	addi	s1,s1,-1358 # 80019020 <log>
    80003576:	4785                	li	a5,1
    80003578:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000357a:	8526                	mv	a0,s1
    8000357c:	00003097          	auipc	ra,0x3
    80003580:	bc0080e7          	jalr	-1088(ra) # 8000613c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003584:	54dc                	lw	a5,44(s1)
    80003586:	06f04763          	bgtz	a5,800035f4 <end_op+0xbc>
    acquire(&log.lock);
    8000358a:	00016497          	auipc	s1,0x16
    8000358e:	a9648493          	addi	s1,s1,-1386 # 80019020 <log>
    80003592:	8526                	mv	a0,s1
    80003594:	00003097          	auipc	ra,0x3
    80003598:	af4080e7          	jalr	-1292(ra) # 80006088 <acquire>
    log.committing = 0;
    8000359c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035a0:	8526                	mv	a0,s1
    800035a2:	ffffe097          	auipc	ra,0xffffe
    800035a6:	0fa080e7          	jalr	250(ra) # 8000169c <wakeup>
    release(&log.lock);
    800035aa:	8526                	mv	a0,s1
    800035ac:	00003097          	auipc	ra,0x3
    800035b0:	b90080e7          	jalr	-1136(ra) # 8000613c <release>
}
    800035b4:	a03d                	j	800035e2 <end_op+0xaa>
    panic("log.committing");
    800035b6:	00005517          	auipc	a0,0x5
    800035ba:	0c250513          	addi	a0,a0,194 # 80008678 <syscalls+0x1e8>
    800035be:	00002097          	auipc	ra,0x2
    800035c2:	592080e7          	jalr	1426(ra) # 80005b50 <panic>
    wakeup(&log);
    800035c6:	00016497          	auipc	s1,0x16
    800035ca:	a5a48493          	addi	s1,s1,-1446 # 80019020 <log>
    800035ce:	8526                	mv	a0,s1
    800035d0:	ffffe097          	auipc	ra,0xffffe
    800035d4:	0cc080e7          	jalr	204(ra) # 8000169c <wakeup>
  release(&log.lock);
    800035d8:	8526                	mv	a0,s1
    800035da:	00003097          	auipc	ra,0x3
    800035de:	b62080e7          	jalr	-1182(ra) # 8000613c <release>
}
    800035e2:	70e2                	ld	ra,56(sp)
    800035e4:	7442                	ld	s0,48(sp)
    800035e6:	74a2                	ld	s1,40(sp)
    800035e8:	7902                	ld	s2,32(sp)
    800035ea:	69e2                	ld	s3,24(sp)
    800035ec:	6a42                	ld	s4,16(sp)
    800035ee:	6aa2                	ld	s5,8(sp)
    800035f0:	6121                	addi	sp,sp,64
    800035f2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f4:	00016a97          	auipc	s5,0x16
    800035f8:	a5ca8a93          	addi	s5,s5,-1444 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035fc:	00016a17          	auipc	s4,0x16
    80003600:	a24a0a13          	addi	s4,s4,-1500 # 80019020 <log>
    80003604:	018a2583          	lw	a1,24(s4)
    80003608:	012585bb          	addw	a1,a1,s2
    8000360c:	2585                	addiw	a1,a1,1
    8000360e:	028a2503          	lw	a0,40(s4)
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	cca080e7          	jalr	-822(ra) # 800022dc <bread>
    8000361a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000361c:	000aa583          	lw	a1,0(s5)
    80003620:	028a2503          	lw	a0,40(s4)
    80003624:	fffff097          	auipc	ra,0xfffff
    80003628:	cb8080e7          	jalr	-840(ra) # 800022dc <bread>
    8000362c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000362e:	40000613          	li	a2,1024
    80003632:	05850593          	addi	a1,a0,88
    80003636:	05848513          	addi	a0,s1,88
    8000363a:	ffffd097          	auipc	ra,0xffffd
    8000363e:	b9c080e7          	jalr	-1124(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003642:	8526                	mv	a0,s1
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	d8a080e7          	jalr	-630(ra) # 800023ce <bwrite>
    brelse(from);
    8000364c:	854e                	mv	a0,s3
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	dbe080e7          	jalr	-578(ra) # 8000240c <brelse>
    brelse(to);
    80003656:	8526                	mv	a0,s1
    80003658:	fffff097          	auipc	ra,0xfffff
    8000365c:	db4080e7          	jalr	-588(ra) # 8000240c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003660:	2905                	addiw	s2,s2,1
    80003662:	0a91                	addi	s5,s5,4
    80003664:	02ca2783          	lw	a5,44(s4)
    80003668:	f8f94ee3          	blt	s2,a5,80003604 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000366c:	00000097          	auipc	ra,0x0
    80003670:	c68080e7          	jalr	-920(ra) # 800032d4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003674:	4501                	li	a0,0
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	cda080e7          	jalr	-806(ra) # 80003350 <install_trans>
    log.lh.n = 0;
    8000367e:	00016797          	auipc	a5,0x16
    80003682:	9c07a723          	sw	zero,-1586(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003686:	00000097          	auipc	ra,0x0
    8000368a:	c4e080e7          	jalr	-946(ra) # 800032d4 <write_head>
    8000368e:	bdf5                	j	8000358a <end_op+0x52>

0000000080003690 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003690:	1101                	addi	sp,sp,-32
    80003692:	ec06                	sd	ra,24(sp)
    80003694:	e822                	sd	s0,16(sp)
    80003696:	e426                	sd	s1,8(sp)
    80003698:	e04a                	sd	s2,0(sp)
    8000369a:	1000                	addi	s0,sp,32
    8000369c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000369e:	00016917          	auipc	s2,0x16
    800036a2:	98290913          	addi	s2,s2,-1662 # 80019020 <log>
    800036a6:	854a                	mv	a0,s2
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	9e0080e7          	jalr	-1568(ra) # 80006088 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036b0:	02c92603          	lw	a2,44(s2)
    800036b4:	47f5                	li	a5,29
    800036b6:	06c7c563          	blt	a5,a2,80003720 <log_write+0x90>
    800036ba:	00016797          	auipc	a5,0x16
    800036be:	9827a783          	lw	a5,-1662(a5) # 8001903c <log+0x1c>
    800036c2:	37fd                	addiw	a5,a5,-1
    800036c4:	04f65e63          	bge	a2,a5,80003720 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036c8:	00016797          	auipc	a5,0x16
    800036cc:	9787a783          	lw	a5,-1672(a5) # 80019040 <log+0x20>
    800036d0:	06f05063          	blez	a5,80003730 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036d4:	4781                	li	a5,0
    800036d6:	06c05563          	blez	a2,80003740 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036da:	44cc                	lw	a1,12(s1)
    800036dc:	00016717          	auipc	a4,0x16
    800036e0:	97470713          	addi	a4,a4,-1676 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036e4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036e6:	4314                	lw	a3,0(a4)
    800036e8:	04b68c63          	beq	a3,a1,80003740 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036ec:	2785                	addiw	a5,a5,1
    800036ee:	0711                	addi	a4,a4,4
    800036f0:	fef61be3          	bne	a2,a5,800036e6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036f4:	0621                	addi	a2,a2,8
    800036f6:	060a                	slli	a2,a2,0x2
    800036f8:	00016797          	auipc	a5,0x16
    800036fc:	92878793          	addi	a5,a5,-1752 # 80019020 <log>
    80003700:	97b2                	add	a5,a5,a2
    80003702:	44d8                	lw	a4,12(s1)
    80003704:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003706:	8526                	mv	a0,s1
    80003708:	fffff097          	auipc	ra,0xfffff
    8000370c:	da2080e7          	jalr	-606(ra) # 800024aa <bpin>
    log.lh.n++;
    80003710:	00016717          	auipc	a4,0x16
    80003714:	91070713          	addi	a4,a4,-1776 # 80019020 <log>
    80003718:	575c                	lw	a5,44(a4)
    8000371a:	2785                	addiw	a5,a5,1
    8000371c:	d75c                	sw	a5,44(a4)
    8000371e:	a82d                	j	80003758 <log_write+0xc8>
    panic("too big a transaction");
    80003720:	00005517          	auipc	a0,0x5
    80003724:	f6850513          	addi	a0,a0,-152 # 80008688 <syscalls+0x1f8>
    80003728:	00002097          	auipc	ra,0x2
    8000372c:	428080e7          	jalr	1064(ra) # 80005b50 <panic>
    panic("log_write outside of trans");
    80003730:	00005517          	auipc	a0,0x5
    80003734:	f7050513          	addi	a0,a0,-144 # 800086a0 <syscalls+0x210>
    80003738:	00002097          	auipc	ra,0x2
    8000373c:	418080e7          	jalr	1048(ra) # 80005b50 <panic>
  log.lh.block[i] = b->blockno;
    80003740:	00878693          	addi	a3,a5,8
    80003744:	068a                	slli	a3,a3,0x2
    80003746:	00016717          	auipc	a4,0x16
    8000374a:	8da70713          	addi	a4,a4,-1830 # 80019020 <log>
    8000374e:	9736                	add	a4,a4,a3
    80003750:	44d4                	lw	a3,12(s1)
    80003752:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003754:	faf609e3          	beq	a2,a5,80003706 <log_write+0x76>
  }
  release(&log.lock);
    80003758:	00016517          	auipc	a0,0x16
    8000375c:	8c850513          	addi	a0,a0,-1848 # 80019020 <log>
    80003760:	00003097          	auipc	ra,0x3
    80003764:	9dc080e7          	jalr	-1572(ra) # 8000613c <release>
}
    80003768:	60e2                	ld	ra,24(sp)
    8000376a:	6442                	ld	s0,16(sp)
    8000376c:	64a2                	ld	s1,8(sp)
    8000376e:	6902                	ld	s2,0(sp)
    80003770:	6105                	addi	sp,sp,32
    80003772:	8082                	ret

0000000080003774 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
    80003780:	84aa                	mv	s1,a0
    80003782:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003784:	00005597          	auipc	a1,0x5
    80003788:	f3c58593          	addi	a1,a1,-196 # 800086c0 <syscalls+0x230>
    8000378c:	0521                	addi	a0,a0,8
    8000378e:	00003097          	auipc	ra,0x3
    80003792:	86a080e7          	jalr	-1942(ra) # 80005ff8 <initlock>
  lk->name = name;
    80003796:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000379a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000379e:	0204a423          	sw	zero,40(s1)
}
    800037a2:	60e2                	ld	ra,24(sp)
    800037a4:	6442                	ld	s0,16(sp)
    800037a6:	64a2                	ld	s1,8(sp)
    800037a8:	6902                	ld	s2,0(sp)
    800037aa:	6105                	addi	sp,sp,32
    800037ac:	8082                	ret

00000000800037ae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	e04a                	sd	s2,0(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037bc:	00850913          	addi	s2,a0,8
    800037c0:	854a                	mv	a0,s2
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	8c6080e7          	jalr	-1850(ra) # 80006088 <acquire>
  while (lk->locked) {
    800037ca:	409c                	lw	a5,0(s1)
    800037cc:	cb89                	beqz	a5,800037de <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037ce:	85ca                	mv	a1,s2
    800037d0:	8526                	mv	a0,s1
    800037d2:	ffffe097          	auipc	ra,0xffffe
    800037d6:	d3e080e7          	jalr	-706(ra) # 80001510 <sleep>
  while (lk->locked) {
    800037da:	409c                	lw	a5,0(s1)
    800037dc:	fbed                	bnez	a5,800037ce <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037de:	4785                	li	a5,1
    800037e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	662080e7          	jalr	1634(ra) # 80000e44 <myproc>
    800037ea:	591c                	lw	a5,48(a0)
    800037ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	94c080e7          	jalr	-1716(ra) # 8000613c <release>
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6902                	ld	s2,0(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret

0000000080003804 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003804:	1101                	addi	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	e04a                	sd	s2,0(sp)
    8000380e:	1000                	addi	s0,sp,32
    80003810:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003812:	00850913          	addi	s2,a0,8
    80003816:	854a                	mv	a0,s2
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	870080e7          	jalr	-1936(ra) # 80006088 <acquire>
  lk->locked = 0;
    80003820:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003824:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003828:	8526                	mv	a0,s1
    8000382a:	ffffe097          	auipc	ra,0xffffe
    8000382e:	e72080e7          	jalr	-398(ra) # 8000169c <wakeup>
  release(&lk->lk);
    80003832:	854a                	mv	a0,s2
    80003834:	00003097          	auipc	ra,0x3
    80003838:	908080e7          	jalr	-1784(ra) # 8000613c <release>
}
    8000383c:	60e2                	ld	ra,24(sp)
    8000383e:	6442                	ld	s0,16(sp)
    80003840:	64a2                	ld	s1,8(sp)
    80003842:	6902                	ld	s2,0(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003848:	7179                	addi	sp,sp,-48
    8000384a:	f406                	sd	ra,40(sp)
    8000384c:	f022                	sd	s0,32(sp)
    8000384e:	ec26                	sd	s1,24(sp)
    80003850:	e84a                	sd	s2,16(sp)
    80003852:	e44e                	sd	s3,8(sp)
    80003854:	1800                	addi	s0,sp,48
    80003856:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003858:	00850913          	addi	s2,a0,8
    8000385c:	854a                	mv	a0,s2
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	82a080e7          	jalr	-2006(ra) # 80006088 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003866:	409c                	lw	a5,0(s1)
    80003868:	ef99                	bnez	a5,80003886 <holdingsleep+0x3e>
    8000386a:	4481                	li	s1,0
  release(&lk->lk);
    8000386c:	854a                	mv	a0,s2
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	8ce080e7          	jalr	-1842(ra) # 8000613c <release>
  return r;
}
    80003876:	8526                	mv	a0,s1
    80003878:	70a2                	ld	ra,40(sp)
    8000387a:	7402                	ld	s0,32(sp)
    8000387c:	64e2                	ld	s1,24(sp)
    8000387e:	6942                	ld	s2,16(sp)
    80003880:	69a2                	ld	s3,8(sp)
    80003882:	6145                	addi	sp,sp,48
    80003884:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003886:	0284a983          	lw	s3,40(s1)
    8000388a:	ffffd097          	auipc	ra,0xffffd
    8000388e:	5ba080e7          	jalr	1466(ra) # 80000e44 <myproc>
    80003892:	5904                	lw	s1,48(a0)
    80003894:	413484b3          	sub	s1,s1,s3
    80003898:	0014b493          	seqz	s1,s1
    8000389c:	bfc1                	j	8000386c <holdingsleep+0x24>

000000008000389e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000389e:	1141                	addi	sp,sp,-16
    800038a0:	e406                	sd	ra,8(sp)
    800038a2:	e022                	sd	s0,0(sp)
    800038a4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038a6:	00005597          	auipc	a1,0x5
    800038aa:	e2a58593          	addi	a1,a1,-470 # 800086d0 <syscalls+0x240>
    800038ae:	00016517          	auipc	a0,0x16
    800038b2:	8ba50513          	addi	a0,a0,-1862 # 80019168 <ftable>
    800038b6:	00002097          	auipc	ra,0x2
    800038ba:	742080e7          	jalr	1858(ra) # 80005ff8 <initlock>
}
    800038be:	60a2                	ld	ra,8(sp)
    800038c0:	6402                	ld	s0,0(sp)
    800038c2:	0141                	addi	sp,sp,16
    800038c4:	8082                	ret

00000000800038c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038d0:	00016517          	auipc	a0,0x16
    800038d4:	89850513          	addi	a0,a0,-1896 # 80019168 <ftable>
    800038d8:	00002097          	auipc	ra,0x2
    800038dc:	7b0080e7          	jalr	1968(ra) # 80006088 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e0:	00016497          	auipc	s1,0x16
    800038e4:	8a048493          	addi	s1,s1,-1888 # 80019180 <ftable+0x18>
    800038e8:	00017717          	auipc	a4,0x17
    800038ec:	83870713          	addi	a4,a4,-1992 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800038f0:	40dc                	lw	a5,4(s1)
    800038f2:	cf99                	beqz	a5,80003910 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038f4:	02848493          	addi	s1,s1,40
    800038f8:	fee49ce3          	bne	s1,a4,800038f0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038fc:	00016517          	auipc	a0,0x16
    80003900:	86c50513          	addi	a0,a0,-1940 # 80019168 <ftable>
    80003904:	00003097          	auipc	ra,0x3
    80003908:	838080e7          	jalr	-1992(ra) # 8000613c <release>
  return 0;
    8000390c:	4481                	li	s1,0
    8000390e:	a819                	j	80003924 <filealloc+0x5e>
      f->ref = 1;
    80003910:	4785                	li	a5,1
    80003912:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003914:	00016517          	auipc	a0,0x16
    80003918:	85450513          	addi	a0,a0,-1964 # 80019168 <ftable>
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	820080e7          	jalr	-2016(ra) # 8000613c <release>
}
    80003924:	8526                	mv	a0,s1
    80003926:	60e2                	ld	ra,24(sp)
    80003928:	6442                	ld	s0,16(sp)
    8000392a:	64a2                	ld	s1,8(sp)
    8000392c:	6105                	addi	sp,sp,32
    8000392e:	8082                	ret

0000000080003930 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003930:	1101                	addi	sp,sp,-32
    80003932:	ec06                	sd	ra,24(sp)
    80003934:	e822                	sd	s0,16(sp)
    80003936:	e426                	sd	s1,8(sp)
    80003938:	1000                	addi	s0,sp,32
    8000393a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000393c:	00016517          	auipc	a0,0x16
    80003940:	82c50513          	addi	a0,a0,-2004 # 80019168 <ftable>
    80003944:	00002097          	auipc	ra,0x2
    80003948:	744080e7          	jalr	1860(ra) # 80006088 <acquire>
  if(f->ref < 1)
    8000394c:	40dc                	lw	a5,4(s1)
    8000394e:	02f05263          	blez	a5,80003972 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003952:	2785                	addiw	a5,a5,1
    80003954:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003956:	00016517          	auipc	a0,0x16
    8000395a:	81250513          	addi	a0,a0,-2030 # 80019168 <ftable>
    8000395e:	00002097          	auipc	ra,0x2
    80003962:	7de080e7          	jalr	2014(ra) # 8000613c <release>
  return f;
}
    80003966:	8526                	mv	a0,s1
    80003968:	60e2                	ld	ra,24(sp)
    8000396a:	6442                	ld	s0,16(sp)
    8000396c:	64a2                	ld	s1,8(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret
    panic("filedup");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	d6650513          	addi	a0,a0,-666 # 800086d8 <syscalls+0x248>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	1d6080e7          	jalr	470(ra) # 80005b50 <panic>

0000000080003982 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003982:	7139                	addi	sp,sp,-64
    80003984:	fc06                	sd	ra,56(sp)
    80003986:	f822                	sd	s0,48(sp)
    80003988:	f426                	sd	s1,40(sp)
    8000398a:	f04a                	sd	s2,32(sp)
    8000398c:	ec4e                	sd	s3,24(sp)
    8000398e:	e852                	sd	s4,16(sp)
    80003990:	e456                	sd	s5,8(sp)
    80003992:	0080                	addi	s0,sp,64
    80003994:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003996:	00015517          	auipc	a0,0x15
    8000399a:	7d250513          	addi	a0,a0,2002 # 80019168 <ftable>
    8000399e:	00002097          	auipc	ra,0x2
    800039a2:	6ea080e7          	jalr	1770(ra) # 80006088 <acquire>
  if(f->ref < 1)
    800039a6:	40dc                	lw	a5,4(s1)
    800039a8:	06f05163          	blez	a5,80003a0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039ac:	37fd                	addiw	a5,a5,-1
    800039ae:	0007871b          	sext.w	a4,a5
    800039b2:	c0dc                	sw	a5,4(s1)
    800039b4:	06e04363          	bgtz	a4,80003a1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039b8:	0004a903          	lw	s2,0(s1)
    800039bc:	0094ca83          	lbu	s5,9(s1)
    800039c0:	0104ba03          	ld	s4,16(s1)
    800039c4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039c8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039cc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039d0:	00015517          	auipc	a0,0x15
    800039d4:	79850513          	addi	a0,a0,1944 # 80019168 <ftable>
    800039d8:	00002097          	auipc	ra,0x2
    800039dc:	764080e7          	jalr	1892(ra) # 8000613c <release>

  if(ff.type == FD_PIPE){
    800039e0:	4785                	li	a5,1
    800039e2:	04f90d63          	beq	s2,a5,80003a3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039e6:	3979                	addiw	s2,s2,-2
    800039e8:	4785                	li	a5,1
    800039ea:	0527e063          	bltu	a5,s2,80003a2a <fileclose+0xa8>
    begin_op();
    800039ee:	00000097          	auipc	ra,0x0
    800039f2:	acc080e7          	jalr	-1332(ra) # 800034ba <begin_op>
    iput(ff.ip);
    800039f6:	854e                	mv	a0,s3
    800039f8:	fffff097          	auipc	ra,0xfffff
    800039fc:	2a0080e7          	jalr	672(ra) # 80002c98 <iput>
    end_op();
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	b38080e7          	jalr	-1224(ra) # 80003538 <end_op>
    80003a08:	a00d                	j	80003a2a <fileclose+0xa8>
    panic("fileclose");
    80003a0a:	00005517          	auipc	a0,0x5
    80003a0e:	cd650513          	addi	a0,a0,-810 # 800086e0 <syscalls+0x250>
    80003a12:	00002097          	auipc	ra,0x2
    80003a16:	13e080e7          	jalr	318(ra) # 80005b50 <panic>
    release(&ftable.lock);
    80003a1a:	00015517          	auipc	a0,0x15
    80003a1e:	74e50513          	addi	a0,a0,1870 # 80019168 <ftable>
    80003a22:	00002097          	auipc	ra,0x2
    80003a26:	71a080e7          	jalr	1818(ra) # 8000613c <release>
  }
}
    80003a2a:	70e2                	ld	ra,56(sp)
    80003a2c:	7442                	ld	s0,48(sp)
    80003a2e:	74a2                	ld	s1,40(sp)
    80003a30:	7902                	ld	s2,32(sp)
    80003a32:	69e2                	ld	s3,24(sp)
    80003a34:	6a42                	ld	s4,16(sp)
    80003a36:	6aa2                	ld	s5,8(sp)
    80003a38:	6121                	addi	sp,sp,64
    80003a3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a3c:	85d6                	mv	a1,s5
    80003a3e:	8552                	mv	a0,s4
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	34c080e7          	jalr	844(ra) # 80003d8c <pipeclose>
    80003a48:	b7cd                	j	80003a2a <fileclose+0xa8>

0000000080003a4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a4a:	715d                	addi	sp,sp,-80
    80003a4c:	e486                	sd	ra,72(sp)
    80003a4e:	e0a2                	sd	s0,64(sp)
    80003a50:	fc26                	sd	s1,56(sp)
    80003a52:	f84a                	sd	s2,48(sp)
    80003a54:	f44e                	sd	s3,40(sp)
    80003a56:	0880                	addi	s0,sp,80
    80003a58:	84aa                	mv	s1,a0
    80003a5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a5c:	ffffd097          	auipc	ra,0xffffd
    80003a60:	3e8080e7          	jalr	1000(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a64:	409c                	lw	a5,0(s1)
    80003a66:	37f9                	addiw	a5,a5,-2
    80003a68:	4705                	li	a4,1
    80003a6a:	04f76763          	bltu	a4,a5,80003ab8 <filestat+0x6e>
    80003a6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a70:	6c88                	ld	a0,24(s1)
    80003a72:	fffff097          	auipc	ra,0xfffff
    80003a76:	06c080e7          	jalr	108(ra) # 80002ade <ilock>
    stati(f->ip, &st);
    80003a7a:	fb840593          	addi	a1,s0,-72
    80003a7e:	6c88                	ld	a0,24(s1)
    80003a80:	fffff097          	auipc	ra,0xfffff
    80003a84:	2e8080e7          	jalr	744(ra) # 80002d68 <stati>
    iunlock(f->ip);
    80003a88:	6c88                	ld	a0,24(s1)
    80003a8a:	fffff097          	auipc	ra,0xfffff
    80003a8e:	116080e7          	jalr	278(ra) # 80002ba0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a92:	46e1                	li	a3,24
    80003a94:	fb840613          	addi	a2,s0,-72
    80003a98:	85ce                	mv	a1,s3
    80003a9a:	05093503          	ld	a0,80(s2)
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	06a080e7          	jalr	106(ra) # 80000b08 <copyout>
    80003aa6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aaa:	60a6                	ld	ra,72(sp)
    80003aac:	6406                	ld	s0,64(sp)
    80003aae:	74e2                	ld	s1,56(sp)
    80003ab0:	7942                	ld	s2,48(sp)
    80003ab2:	79a2                	ld	s3,40(sp)
    80003ab4:	6161                	addi	sp,sp,80
    80003ab6:	8082                	ret
  return -1;
    80003ab8:	557d                	li	a0,-1
    80003aba:	bfc5                	j	80003aaa <filestat+0x60>

0000000080003abc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003abc:	7179                	addi	sp,sp,-48
    80003abe:	f406                	sd	ra,40(sp)
    80003ac0:	f022                	sd	s0,32(sp)
    80003ac2:	ec26                	sd	s1,24(sp)
    80003ac4:	e84a                	sd	s2,16(sp)
    80003ac6:	e44e                	sd	s3,8(sp)
    80003ac8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003aca:	00854783          	lbu	a5,8(a0)
    80003ace:	c3d5                	beqz	a5,80003b72 <fileread+0xb6>
    80003ad0:	84aa                	mv	s1,a0
    80003ad2:	89ae                	mv	s3,a1
    80003ad4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ad6:	411c                	lw	a5,0(a0)
    80003ad8:	4705                	li	a4,1
    80003ada:	04e78963          	beq	a5,a4,80003b2c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ade:	470d                	li	a4,3
    80003ae0:	04e78d63          	beq	a5,a4,80003b3a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ae4:	4709                	li	a4,2
    80003ae6:	06e79e63          	bne	a5,a4,80003b62 <fileread+0xa6>
    ilock(f->ip);
    80003aea:	6d08                	ld	a0,24(a0)
    80003aec:	fffff097          	auipc	ra,0xfffff
    80003af0:	ff2080e7          	jalr	-14(ra) # 80002ade <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003af4:	874a                	mv	a4,s2
    80003af6:	5094                	lw	a3,32(s1)
    80003af8:	864e                	mv	a2,s3
    80003afa:	4585                	li	a1,1
    80003afc:	6c88                	ld	a0,24(s1)
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	294080e7          	jalr	660(ra) # 80002d92 <readi>
    80003b06:	892a                	mv	s2,a0
    80003b08:	00a05563          	blez	a0,80003b12 <fileread+0x56>
      f->off += r;
    80003b0c:	509c                	lw	a5,32(s1)
    80003b0e:	9fa9                	addw	a5,a5,a0
    80003b10:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b12:	6c88                	ld	a0,24(s1)
    80003b14:	fffff097          	auipc	ra,0xfffff
    80003b18:	08c080e7          	jalr	140(ra) # 80002ba0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b1c:	854a                	mv	a0,s2
    80003b1e:	70a2                	ld	ra,40(sp)
    80003b20:	7402                	ld	s0,32(sp)
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	6942                	ld	s2,16(sp)
    80003b26:	69a2                	ld	s3,8(sp)
    80003b28:	6145                	addi	sp,sp,48
    80003b2a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b2c:	6908                	ld	a0,16(a0)
    80003b2e:	00000097          	auipc	ra,0x0
    80003b32:	3c0080e7          	jalr	960(ra) # 80003eee <piperead>
    80003b36:	892a                	mv	s2,a0
    80003b38:	b7d5                	j	80003b1c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b3a:	02451783          	lh	a5,36(a0)
    80003b3e:	03079693          	slli	a3,a5,0x30
    80003b42:	92c1                	srli	a3,a3,0x30
    80003b44:	4725                	li	a4,9
    80003b46:	02d76863          	bltu	a4,a3,80003b76 <fileread+0xba>
    80003b4a:	0792                	slli	a5,a5,0x4
    80003b4c:	00015717          	auipc	a4,0x15
    80003b50:	57c70713          	addi	a4,a4,1404 # 800190c8 <devsw>
    80003b54:	97ba                	add	a5,a5,a4
    80003b56:	639c                	ld	a5,0(a5)
    80003b58:	c38d                	beqz	a5,80003b7a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b5a:	4505                	li	a0,1
    80003b5c:	9782                	jalr	a5
    80003b5e:	892a                	mv	s2,a0
    80003b60:	bf75                	j	80003b1c <fileread+0x60>
    panic("fileread");
    80003b62:	00005517          	auipc	a0,0x5
    80003b66:	b8e50513          	addi	a0,a0,-1138 # 800086f0 <syscalls+0x260>
    80003b6a:	00002097          	auipc	ra,0x2
    80003b6e:	fe6080e7          	jalr	-26(ra) # 80005b50 <panic>
    return -1;
    80003b72:	597d                	li	s2,-1
    80003b74:	b765                	j	80003b1c <fileread+0x60>
      return -1;
    80003b76:	597d                	li	s2,-1
    80003b78:	b755                	j	80003b1c <fileread+0x60>
    80003b7a:	597d                	li	s2,-1
    80003b7c:	b745                	j	80003b1c <fileread+0x60>

0000000080003b7e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b7e:	715d                	addi	sp,sp,-80
    80003b80:	e486                	sd	ra,72(sp)
    80003b82:	e0a2                	sd	s0,64(sp)
    80003b84:	fc26                	sd	s1,56(sp)
    80003b86:	f84a                	sd	s2,48(sp)
    80003b88:	f44e                	sd	s3,40(sp)
    80003b8a:	f052                	sd	s4,32(sp)
    80003b8c:	ec56                	sd	s5,24(sp)
    80003b8e:	e85a                	sd	s6,16(sp)
    80003b90:	e45e                	sd	s7,8(sp)
    80003b92:	e062                	sd	s8,0(sp)
    80003b94:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b96:	00954783          	lbu	a5,9(a0)
    80003b9a:	10078663          	beqz	a5,80003ca6 <filewrite+0x128>
    80003b9e:	892a                	mv	s2,a0
    80003ba0:	8b2e                	mv	s6,a1
    80003ba2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ba4:	411c                	lw	a5,0(a0)
    80003ba6:	4705                	li	a4,1
    80003ba8:	02e78263          	beq	a5,a4,80003bcc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bac:	470d                	li	a4,3
    80003bae:	02e78663          	beq	a5,a4,80003bda <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bb2:	4709                	li	a4,2
    80003bb4:	0ee79163          	bne	a5,a4,80003c96 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003bb8:	0ac05d63          	blez	a2,80003c72 <filewrite+0xf4>
    int i = 0;
    80003bbc:	4981                	li	s3,0
    80003bbe:	6b85                	lui	s7,0x1
    80003bc0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003bc4:	6c05                	lui	s8,0x1
    80003bc6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bca:	a861                	j	80003c62 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bcc:	6908                	ld	a0,16(a0)
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	22e080e7          	jalr	558(ra) # 80003dfc <pipewrite>
    80003bd6:	8a2a                	mv	s4,a0
    80003bd8:	a045                	j	80003c78 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bda:	02451783          	lh	a5,36(a0)
    80003bde:	03079693          	slli	a3,a5,0x30
    80003be2:	92c1                	srli	a3,a3,0x30
    80003be4:	4725                	li	a4,9
    80003be6:	0cd76263          	bltu	a4,a3,80003caa <filewrite+0x12c>
    80003bea:	0792                	slli	a5,a5,0x4
    80003bec:	00015717          	auipc	a4,0x15
    80003bf0:	4dc70713          	addi	a4,a4,1244 # 800190c8 <devsw>
    80003bf4:	97ba                	add	a5,a5,a4
    80003bf6:	679c                	ld	a5,8(a5)
    80003bf8:	cbdd                	beqz	a5,80003cae <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003bfa:	4505                	li	a0,1
    80003bfc:	9782                	jalr	a5
    80003bfe:	8a2a                	mv	s4,a0
    80003c00:	a8a5                	j	80003c78 <filewrite+0xfa>
    80003c02:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c06:	00000097          	auipc	ra,0x0
    80003c0a:	8b4080e7          	jalr	-1868(ra) # 800034ba <begin_op>
      ilock(f->ip);
    80003c0e:	01893503          	ld	a0,24(s2)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	ecc080e7          	jalr	-308(ra) # 80002ade <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c1a:	8756                	mv	a4,s5
    80003c1c:	02092683          	lw	a3,32(s2)
    80003c20:	01698633          	add	a2,s3,s6
    80003c24:	4585                	li	a1,1
    80003c26:	01893503          	ld	a0,24(s2)
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	260080e7          	jalr	608(ra) # 80002e8a <writei>
    80003c32:	84aa                	mv	s1,a0
    80003c34:	00a05763          	blez	a0,80003c42 <filewrite+0xc4>
        f->off += r;
    80003c38:	02092783          	lw	a5,32(s2)
    80003c3c:	9fa9                	addw	a5,a5,a0
    80003c3e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c42:	01893503          	ld	a0,24(s2)
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	f5a080e7          	jalr	-166(ra) # 80002ba0 <iunlock>
      end_op();
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	8ea080e7          	jalr	-1814(ra) # 80003538 <end_op>

      if(r != n1){
    80003c56:	009a9f63          	bne	s5,s1,80003c74 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c5a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c5e:	0149db63          	bge	s3,s4,80003c74 <filewrite+0xf6>
      int n1 = n - i;
    80003c62:	413a04bb          	subw	s1,s4,s3
    80003c66:	0004879b          	sext.w	a5,s1
    80003c6a:	f8fbdce3          	bge	s7,a5,80003c02 <filewrite+0x84>
    80003c6e:	84e2                	mv	s1,s8
    80003c70:	bf49                	j	80003c02 <filewrite+0x84>
    int i = 0;
    80003c72:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c74:	013a1f63          	bne	s4,s3,80003c92 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c78:	8552                	mv	a0,s4
    80003c7a:	60a6                	ld	ra,72(sp)
    80003c7c:	6406                	ld	s0,64(sp)
    80003c7e:	74e2                	ld	s1,56(sp)
    80003c80:	7942                	ld	s2,48(sp)
    80003c82:	79a2                	ld	s3,40(sp)
    80003c84:	7a02                	ld	s4,32(sp)
    80003c86:	6ae2                	ld	s5,24(sp)
    80003c88:	6b42                	ld	s6,16(sp)
    80003c8a:	6ba2                	ld	s7,8(sp)
    80003c8c:	6c02                	ld	s8,0(sp)
    80003c8e:	6161                	addi	sp,sp,80
    80003c90:	8082                	ret
    ret = (i == n ? n : -1);
    80003c92:	5a7d                	li	s4,-1
    80003c94:	b7d5                	j	80003c78 <filewrite+0xfa>
    panic("filewrite");
    80003c96:	00005517          	auipc	a0,0x5
    80003c9a:	a6a50513          	addi	a0,a0,-1430 # 80008700 <syscalls+0x270>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	eb2080e7          	jalr	-334(ra) # 80005b50 <panic>
    return -1;
    80003ca6:	5a7d                	li	s4,-1
    80003ca8:	bfc1                	j	80003c78 <filewrite+0xfa>
      return -1;
    80003caa:	5a7d                	li	s4,-1
    80003cac:	b7f1                	j	80003c78 <filewrite+0xfa>
    80003cae:	5a7d                	li	s4,-1
    80003cb0:	b7e1                	j	80003c78 <filewrite+0xfa>

0000000080003cb2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cb2:	7179                	addi	sp,sp,-48
    80003cb4:	f406                	sd	ra,40(sp)
    80003cb6:	f022                	sd	s0,32(sp)
    80003cb8:	ec26                	sd	s1,24(sp)
    80003cba:	e84a                	sd	s2,16(sp)
    80003cbc:	e44e                	sd	s3,8(sp)
    80003cbe:	e052                	sd	s4,0(sp)
    80003cc0:	1800                	addi	s0,sp,48
    80003cc2:	84aa                	mv	s1,a0
    80003cc4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cc6:	0005b023          	sd	zero,0(a1)
    80003cca:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	bf8080e7          	jalr	-1032(ra) # 800038c6 <filealloc>
    80003cd6:	e088                	sd	a0,0(s1)
    80003cd8:	c551                	beqz	a0,80003d64 <pipealloc+0xb2>
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	bec080e7          	jalr	-1044(ra) # 800038c6 <filealloc>
    80003ce2:	00aa3023          	sd	a0,0(s4)
    80003ce6:	c92d                	beqz	a0,80003d58 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ce8:	ffffc097          	auipc	ra,0xffffc
    80003cec:	432080e7          	jalr	1074(ra) # 8000011a <kalloc>
    80003cf0:	892a                	mv	s2,a0
    80003cf2:	c125                	beqz	a0,80003d52 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cf4:	4985                	li	s3,1
    80003cf6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cfa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cfe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d02:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d06:	00004597          	auipc	a1,0x4
    80003d0a:	6e258593          	addi	a1,a1,1762 # 800083e8 <states.0+0x1a8>
    80003d0e:	00002097          	auipc	ra,0x2
    80003d12:	2ea080e7          	jalr	746(ra) # 80005ff8 <initlock>
  (*f0)->type = FD_PIPE;
    80003d16:	609c                	ld	a5,0(s1)
    80003d18:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d1c:	609c                	ld	a5,0(s1)
    80003d1e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d22:	609c                	ld	a5,0(s1)
    80003d24:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d28:	609c                	ld	a5,0(s1)
    80003d2a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d2e:	000a3783          	ld	a5,0(s4)
    80003d32:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d36:	000a3783          	ld	a5,0(s4)
    80003d3a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d3e:	000a3783          	ld	a5,0(s4)
    80003d42:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d46:	000a3783          	ld	a5,0(s4)
    80003d4a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d4e:	4501                	li	a0,0
    80003d50:	a025                	j	80003d78 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d52:	6088                	ld	a0,0(s1)
    80003d54:	e501                	bnez	a0,80003d5c <pipealloc+0xaa>
    80003d56:	a039                	j	80003d64 <pipealloc+0xb2>
    80003d58:	6088                	ld	a0,0(s1)
    80003d5a:	c51d                	beqz	a0,80003d88 <pipealloc+0xd6>
    fileclose(*f0);
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	c26080e7          	jalr	-986(ra) # 80003982 <fileclose>
  if(*f1)
    80003d64:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d68:	557d                	li	a0,-1
  if(*f1)
    80003d6a:	c799                	beqz	a5,80003d78 <pipealloc+0xc6>
    fileclose(*f1);
    80003d6c:	853e                	mv	a0,a5
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	c14080e7          	jalr	-1004(ra) # 80003982 <fileclose>
  return -1;
    80003d76:	557d                	li	a0,-1
}
    80003d78:	70a2                	ld	ra,40(sp)
    80003d7a:	7402                	ld	s0,32(sp)
    80003d7c:	64e2                	ld	s1,24(sp)
    80003d7e:	6942                	ld	s2,16(sp)
    80003d80:	69a2                	ld	s3,8(sp)
    80003d82:	6a02                	ld	s4,0(sp)
    80003d84:	6145                	addi	sp,sp,48
    80003d86:	8082                	ret
  return -1;
    80003d88:	557d                	li	a0,-1
    80003d8a:	b7fd                	j	80003d78 <pipealloc+0xc6>

0000000080003d8c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d8c:	1101                	addi	sp,sp,-32
    80003d8e:	ec06                	sd	ra,24(sp)
    80003d90:	e822                	sd	s0,16(sp)
    80003d92:	e426                	sd	s1,8(sp)
    80003d94:	e04a                	sd	s2,0(sp)
    80003d96:	1000                	addi	s0,sp,32
    80003d98:	84aa                	mv	s1,a0
    80003d9a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d9c:	00002097          	auipc	ra,0x2
    80003da0:	2ec080e7          	jalr	748(ra) # 80006088 <acquire>
  if(writable){
    80003da4:	02090d63          	beqz	s2,80003dde <pipeclose+0x52>
    pi->writeopen = 0;
    80003da8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003dac:	21848513          	addi	a0,s1,536
    80003db0:	ffffe097          	auipc	ra,0xffffe
    80003db4:	8ec080e7          	jalr	-1812(ra) # 8000169c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003db8:	2204b783          	ld	a5,544(s1)
    80003dbc:	eb95                	bnez	a5,80003df0 <pipeclose+0x64>
    release(&pi->lock);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	00002097          	auipc	ra,0x2
    80003dc4:	37c080e7          	jalr	892(ra) # 8000613c <release>
    kfree((char*)pi);
    80003dc8:	8526                	mv	a0,s1
    80003dca:	ffffc097          	auipc	ra,0xffffc
    80003dce:	252080e7          	jalr	594(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dd2:	60e2                	ld	ra,24(sp)
    80003dd4:	6442                	ld	s0,16(sp)
    80003dd6:	64a2                	ld	s1,8(sp)
    80003dd8:	6902                	ld	s2,0(sp)
    80003dda:	6105                	addi	sp,sp,32
    80003ddc:	8082                	ret
    pi->readopen = 0;
    80003dde:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003de2:	21c48513          	addi	a0,s1,540
    80003de6:	ffffe097          	auipc	ra,0xffffe
    80003dea:	8b6080e7          	jalr	-1866(ra) # 8000169c <wakeup>
    80003dee:	b7e9                	j	80003db8 <pipeclose+0x2c>
    release(&pi->lock);
    80003df0:	8526                	mv	a0,s1
    80003df2:	00002097          	auipc	ra,0x2
    80003df6:	34a080e7          	jalr	842(ra) # 8000613c <release>
}
    80003dfa:	bfe1                	j	80003dd2 <pipeclose+0x46>

0000000080003dfc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dfc:	711d                	addi	sp,sp,-96
    80003dfe:	ec86                	sd	ra,88(sp)
    80003e00:	e8a2                	sd	s0,80(sp)
    80003e02:	e4a6                	sd	s1,72(sp)
    80003e04:	e0ca                	sd	s2,64(sp)
    80003e06:	fc4e                	sd	s3,56(sp)
    80003e08:	f852                	sd	s4,48(sp)
    80003e0a:	f456                	sd	s5,40(sp)
    80003e0c:	f05a                	sd	s6,32(sp)
    80003e0e:	ec5e                	sd	s7,24(sp)
    80003e10:	e862                	sd	s8,16(sp)
    80003e12:	1080                	addi	s0,sp,96
    80003e14:	84aa                	mv	s1,a0
    80003e16:	8aae                	mv	s5,a1
    80003e18:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e1a:	ffffd097          	auipc	ra,0xffffd
    80003e1e:	02a080e7          	jalr	42(ra) # 80000e44 <myproc>
    80003e22:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e24:	8526                	mv	a0,s1
    80003e26:	00002097          	auipc	ra,0x2
    80003e2a:	262080e7          	jalr	610(ra) # 80006088 <acquire>
  while(i < n){
    80003e2e:	0b405363          	blez	s4,80003ed4 <pipewrite+0xd8>
  int i = 0;
    80003e32:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e34:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e36:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e3a:	21c48b93          	addi	s7,s1,540
    80003e3e:	a089                	j	80003e80 <pipewrite+0x84>
      release(&pi->lock);
    80003e40:	8526                	mv	a0,s1
    80003e42:	00002097          	auipc	ra,0x2
    80003e46:	2fa080e7          	jalr	762(ra) # 8000613c <release>
      return -1;
    80003e4a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e4c:	854a                	mv	a0,s2
    80003e4e:	60e6                	ld	ra,88(sp)
    80003e50:	6446                	ld	s0,80(sp)
    80003e52:	64a6                	ld	s1,72(sp)
    80003e54:	6906                	ld	s2,64(sp)
    80003e56:	79e2                	ld	s3,56(sp)
    80003e58:	7a42                	ld	s4,48(sp)
    80003e5a:	7aa2                	ld	s5,40(sp)
    80003e5c:	7b02                	ld	s6,32(sp)
    80003e5e:	6be2                	ld	s7,24(sp)
    80003e60:	6c42                	ld	s8,16(sp)
    80003e62:	6125                	addi	sp,sp,96
    80003e64:	8082                	ret
      wakeup(&pi->nread);
    80003e66:	8562                	mv	a0,s8
    80003e68:	ffffe097          	auipc	ra,0xffffe
    80003e6c:	834080e7          	jalr	-1996(ra) # 8000169c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e70:	85a6                	mv	a1,s1
    80003e72:	855e                	mv	a0,s7
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	69c080e7          	jalr	1692(ra) # 80001510 <sleep>
  while(i < n){
    80003e7c:	05495d63          	bge	s2,s4,80003ed6 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003e80:	2204a783          	lw	a5,544(s1)
    80003e84:	dfd5                	beqz	a5,80003e40 <pipewrite+0x44>
    80003e86:	0289a783          	lw	a5,40(s3)
    80003e8a:	fbdd                	bnez	a5,80003e40 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e8c:	2184a783          	lw	a5,536(s1)
    80003e90:	21c4a703          	lw	a4,540(s1)
    80003e94:	2007879b          	addiw	a5,a5,512
    80003e98:	fcf707e3          	beq	a4,a5,80003e66 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e9c:	4685                	li	a3,1
    80003e9e:	01590633          	add	a2,s2,s5
    80003ea2:	faf40593          	addi	a1,s0,-81
    80003ea6:	0509b503          	ld	a0,80(s3)
    80003eaa:	ffffd097          	auipc	ra,0xffffd
    80003eae:	cea080e7          	jalr	-790(ra) # 80000b94 <copyin>
    80003eb2:	03650263          	beq	a0,s6,80003ed6 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003eb6:	21c4a783          	lw	a5,540(s1)
    80003eba:	0017871b          	addiw	a4,a5,1
    80003ebe:	20e4ae23          	sw	a4,540(s1)
    80003ec2:	1ff7f793          	andi	a5,a5,511
    80003ec6:	97a6                	add	a5,a5,s1
    80003ec8:	faf44703          	lbu	a4,-81(s0)
    80003ecc:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ed0:	2905                	addiw	s2,s2,1
    80003ed2:	b76d                	j	80003e7c <pipewrite+0x80>
  int i = 0;
    80003ed4:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ed6:	21848513          	addi	a0,s1,536
    80003eda:	ffffd097          	auipc	ra,0xffffd
    80003ede:	7c2080e7          	jalr	1986(ra) # 8000169c <wakeup>
  release(&pi->lock);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	00002097          	auipc	ra,0x2
    80003ee8:	258080e7          	jalr	600(ra) # 8000613c <release>
  return i;
    80003eec:	b785                	j	80003e4c <pipewrite+0x50>

0000000080003eee <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003eee:	715d                	addi	sp,sp,-80
    80003ef0:	e486                	sd	ra,72(sp)
    80003ef2:	e0a2                	sd	s0,64(sp)
    80003ef4:	fc26                	sd	s1,56(sp)
    80003ef6:	f84a                	sd	s2,48(sp)
    80003ef8:	f44e                	sd	s3,40(sp)
    80003efa:	f052                	sd	s4,32(sp)
    80003efc:	ec56                	sd	s5,24(sp)
    80003efe:	e85a                	sd	s6,16(sp)
    80003f00:	0880                	addi	s0,sp,80
    80003f02:	84aa                	mv	s1,a0
    80003f04:	892e                	mv	s2,a1
    80003f06:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	f3c080e7          	jalr	-196(ra) # 80000e44 <myproc>
    80003f10:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f12:	8526                	mv	a0,s1
    80003f14:	00002097          	auipc	ra,0x2
    80003f18:	174080e7          	jalr	372(ra) # 80006088 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f1c:	2184a703          	lw	a4,536(s1)
    80003f20:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f24:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f28:	02f71463          	bne	a4,a5,80003f50 <piperead+0x62>
    80003f2c:	2244a783          	lw	a5,548(s1)
    80003f30:	c385                	beqz	a5,80003f50 <piperead+0x62>
    if(pr->killed){
    80003f32:	028a2783          	lw	a5,40(s4)
    80003f36:	ebc9                	bnez	a5,80003fc8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f38:	85a6                	mv	a1,s1
    80003f3a:	854e                	mv	a0,s3
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	5d4080e7          	jalr	1492(ra) # 80001510 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f44:	2184a703          	lw	a4,536(s1)
    80003f48:	21c4a783          	lw	a5,540(s1)
    80003f4c:	fef700e3          	beq	a4,a5,80003f2c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f50:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f52:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f54:	05505463          	blez	s5,80003f9c <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80003f58:	2184a783          	lw	a5,536(s1)
    80003f5c:	21c4a703          	lw	a4,540(s1)
    80003f60:	02f70e63          	beq	a4,a5,80003f9c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f64:	0017871b          	addiw	a4,a5,1
    80003f68:	20e4ac23          	sw	a4,536(s1)
    80003f6c:	1ff7f793          	andi	a5,a5,511
    80003f70:	97a6                	add	a5,a5,s1
    80003f72:	0187c783          	lbu	a5,24(a5)
    80003f76:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f7a:	4685                	li	a3,1
    80003f7c:	fbf40613          	addi	a2,s0,-65
    80003f80:	85ca                	mv	a1,s2
    80003f82:	050a3503          	ld	a0,80(s4)
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	b82080e7          	jalr	-1150(ra) # 80000b08 <copyout>
    80003f8e:	01650763          	beq	a0,s6,80003f9c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f92:	2985                	addiw	s3,s3,1
    80003f94:	0905                	addi	s2,s2,1
    80003f96:	fd3a91e3          	bne	s5,s3,80003f58 <piperead+0x6a>
    80003f9a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f9c:	21c48513          	addi	a0,s1,540
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	6fc080e7          	jalr	1788(ra) # 8000169c <wakeup>
  release(&pi->lock);
    80003fa8:	8526                	mv	a0,s1
    80003faa:	00002097          	auipc	ra,0x2
    80003fae:	192080e7          	jalr	402(ra) # 8000613c <release>
  return i;
}
    80003fb2:	854e                	mv	a0,s3
    80003fb4:	60a6                	ld	ra,72(sp)
    80003fb6:	6406                	ld	s0,64(sp)
    80003fb8:	74e2                	ld	s1,56(sp)
    80003fba:	7942                	ld	s2,48(sp)
    80003fbc:	79a2                	ld	s3,40(sp)
    80003fbe:	7a02                	ld	s4,32(sp)
    80003fc0:	6ae2                	ld	s5,24(sp)
    80003fc2:	6b42                	ld	s6,16(sp)
    80003fc4:	6161                	addi	sp,sp,80
    80003fc6:	8082                	ret
      release(&pi->lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	172080e7          	jalr	370(ra) # 8000613c <release>
      return -1;
    80003fd2:	59fd                	li	s3,-1
    80003fd4:	bff9                	j	80003fb2 <piperead+0xc4>

0000000080003fd6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003fd6:	de010113          	addi	sp,sp,-544
    80003fda:	20113c23          	sd	ra,536(sp)
    80003fde:	20813823          	sd	s0,528(sp)
    80003fe2:	20913423          	sd	s1,520(sp)
    80003fe6:	21213023          	sd	s2,512(sp)
    80003fea:	ffce                	sd	s3,504(sp)
    80003fec:	fbd2                	sd	s4,496(sp)
    80003fee:	f7d6                	sd	s5,488(sp)
    80003ff0:	f3da                	sd	s6,480(sp)
    80003ff2:	efde                	sd	s7,472(sp)
    80003ff4:	ebe2                	sd	s8,464(sp)
    80003ff6:	e7e6                	sd	s9,456(sp)
    80003ff8:	e3ea                	sd	s10,448(sp)
    80003ffa:	ff6e                	sd	s11,440(sp)
    80003ffc:	1400                	addi	s0,sp,544
    80003ffe:	892a                	mv	s2,a0
    80004000:	dea43423          	sd	a0,-536(s0)
    80004004:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	e3c080e7          	jalr	-452(ra) # 80000e44 <myproc>
    80004010:	84aa                	mv	s1,a0

  begin_op();
    80004012:	fffff097          	auipc	ra,0xfffff
    80004016:	4a8080e7          	jalr	1192(ra) # 800034ba <begin_op>

  if((ip = namei(path)) == 0){
    8000401a:	854a                	mv	a0,s2
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	27e080e7          	jalr	638(ra) # 8000329a <namei>
    80004024:	c93d                	beqz	a0,8000409a <exec+0xc4>
    80004026:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	ab6080e7          	jalr	-1354(ra) # 80002ade <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004030:	04000713          	li	a4,64
    80004034:	4681                	li	a3,0
    80004036:	e5040613          	addi	a2,s0,-432
    8000403a:	4581                	li	a1,0
    8000403c:	8556                	mv	a0,s5
    8000403e:	fffff097          	auipc	ra,0xfffff
    80004042:	d54080e7          	jalr	-684(ra) # 80002d92 <readi>
    80004046:	04000793          	li	a5,64
    8000404a:	00f51a63          	bne	a0,a5,8000405e <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000404e:	e5042703          	lw	a4,-432(s0)
    80004052:	464c47b7          	lui	a5,0x464c4
    80004056:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000405a:	04f70663          	beq	a4,a5,800040a6 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000405e:	8556                	mv	a0,s5
    80004060:	fffff097          	auipc	ra,0xfffff
    80004064:	ce0080e7          	jalr	-800(ra) # 80002d40 <iunlockput>
    end_op();
    80004068:	fffff097          	auipc	ra,0xfffff
    8000406c:	4d0080e7          	jalr	1232(ra) # 80003538 <end_op>
  }
  return -1;
    80004070:	557d                	li	a0,-1
}
    80004072:	21813083          	ld	ra,536(sp)
    80004076:	21013403          	ld	s0,528(sp)
    8000407a:	20813483          	ld	s1,520(sp)
    8000407e:	20013903          	ld	s2,512(sp)
    80004082:	79fe                	ld	s3,504(sp)
    80004084:	7a5e                	ld	s4,496(sp)
    80004086:	7abe                	ld	s5,488(sp)
    80004088:	7b1e                	ld	s6,480(sp)
    8000408a:	6bfe                	ld	s7,472(sp)
    8000408c:	6c5e                	ld	s8,464(sp)
    8000408e:	6cbe                	ld	s9,456(sp)
    80004090:	6d1e                	ld	s10,448(sp)
    80004092:	7dfa                	ld	s11,440(sp)
    80004094:	22010113          	addi	sp,sp,544
    80004098:	8082                	ret
    end_op();
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	49e080e7          	jalr	1182(ra) # 80003538 <end_op>
    return -1;
    800040a2:	557d                	li	a0,-1
    800040a4:	b7f9                	j	80004072 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040a6:	8526                	mv	a0,s1
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	e60080e7          	jalr	-416(ra) # 80000f08 <proc_pagetable>
    800040b0:	8b2a                	mv	s6,a0
    800040b2:	d555                	beqz	a0,8000405e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040b4:	e7042783          	lw	a5,-400(s0)
    800040b8:	e8845703          	lhu	a4,-376(s0)
    800040bc:	c735                	beqz	a4,80004128 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040be:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040c0:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800040c4:	6a05                	lui	s4,0x1
    800040c6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040ca:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040ce:	6d85                	lui	s11,0x1
    800040d0:	7d7d                	lui	s10,0xfffff
    800040d2:	ac1d                	j	80004308 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040d4:	00004517          	auipc	a0,0x4
    800040d8:	63c50513          	addi	a0,a0,1596 # 80008710 <syscalls+0x280>
    800040dc:	00002097          	auipc	ra,0x2
    800040e0:	a74080e7          	jalr	-1420(ra) # 80005b50 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040e4:	874a                	mv	a4,s2
    800040e6:	009c86bb          	addw	a3,s9,s1
    800040ea:	4581                	li	a1,0
    800040ec:	8556                	mv	a0,s5
    800040ee:	fffff097          	auipc	ra,0xfffff
    800040f2:	ca4080e7          	jalr	-860(ra) # 80002d92 <readi>
    800040f6:	2501                	sext.w	a0,a0
    800040f8:	1aa91863          	bne	s2,a0,800042a8 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800040fc:	009d84bb          	addw	s1,s11,s1
    80004100:	013d09bb          	addw	s3,s10,s3
    80004104:	1f74f263          	bgeu	s1,s7,800042e8 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004108:	02049593          	slli	a1,s1,0x20
    8000410c:	9181                	srli	a1,a1,0x20
    8000410e:	95e2                	add	a1,a1,s8
    80004110:	855a                	mv	a0,s6
    80004112:	ffffc097          	auipc	ra,0xffffc
    80004116:	3ee080e7          	jalr	1006(ra) # 80000500 <walkaddr>
    8000411a:	862a                	mv	a2,a0
    if(pa == 0)
    8000411c:	dd45                	beqz	a0,800040d4 <exec+0xfe>
      n = PGSIZE;
    8000411e:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004120:	fd49f2e3          	bgeu	s3,s4,800040e4 <exec+0x10e>
      n = sz - i;
    80004124:	894e                	mv	s2,s3
    80004126:	bf7d                	j	800040e4 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004128:	4481                	li	s1,0
  iunlockput(ip);
    8000412a:	8556                	mv	a0,s5
    8000412c:	fffff097          	auipc	ra,0xfffff
    80004130:	c14080e7          	jalr	-1004(ra) # 80002d40 <iunlockput>
  end_op();
    80004134:	fffff097          	auipc	ra,0xfffff
    80004138:	404080e7          	jalr	1028(ra) # 80003538 <end_op>
  p = myproc();
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	d08080e7          	jalr	-760(ra) # 80000e44 <myproc>
    80004144:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004146:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000414a:	6785                	lui	a5,0x1
    8000414c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000414e:	97a6                	add	a5,a5,s1
    80004150:	777d                	lui	a4,0xfffff
    80004152:	8ff9                	and	a5,a5,a4
    80004154:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004158:	6609                	lui	a2,0x2
    8000415a:	963e                	add	a2,a2,a5
    8000415c:	85be                	mv	a1,a5
    8000415e:	855a                	mv	a0,s6
    80004160:	ffffc097          	auipc	ra,0xffffc
    80004164:	754080e7          	jalr	1876(ra) # 800008b4 <uvmalloc>
    80004168:	8c2a                	mv	s8,a0
  ip = 0;
    8000416a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000416c:	12050e63          	beqz	a0,800042a8 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004170:	75f9                	lui	a1,0xffffe
    80004172:	95aa                	add	a1,a1,a0
    80004174:	855a                	mv	a0,s6
    80004176:	ffffd097          	auipc	ra,0xffffd
    8000417a:	960080e7          	jalr	-1696(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000417e:	7afd                	lui	s5,0xfffff
    80004180:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004182:	df043783          	ld	a5,-528(s0)
    80004186:	6388                	ld	a0,0(a5)
    80004188:	c925                	beqz	a0,800041f8 <exec+0x222>
    8000418a:	e9040993          	addi	s3,s0,-368
    8000418e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004192:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004194:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004196:	ffffc097          	auipc	ra,0xffffc
    8000419a:	160080e7          	jalr	352(ra) # 800002f6 <strlen>
    8000419e:	0015079b          	addiw	a5,a0,1
    800041a2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041a6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800041aa:	13596363          	bltu	s2,s5,800042d0 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041ae:	df043d83          	ld	s11,-528(s0)
    800041b2:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041b6:	8552                	mv	a0,s4
    800041b8:	ffffc097          	auipc	ra,0xffffc
    800041bc:	13e080e7          	jalr	318(ra) # 800002f6 <strlen>
    800041c0:	0015069b          	addiw	a3,a0,1
    800041c4:	8652                	mv	a2,s4
    800041c6:	85ca                	mv	a1,s2
    800041c8:	855a                	mv	a0,s6
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	93e080e7          	jalr	-1730(ra) # 80000b08 <copyout>
    800041d2:	10054363          	bltz	a0,800042d8 <exec+0x302>
    ustack[argc] = sp;
    800041d6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041da:	0485                	addi	s1,s1,1
    800041dc:	008d8793          	addi	a5,s11,8
    800041e0:	def43823          	sd	a5,-528(s0)
    800041e4:	008db503          	ld	a0,8(s11)
    800041e8:	c911                	beqz	a0,800041fc <exec+0x226>
    if(argc >= MAXARG)
    800041ea:	09a1                	addi	s3,s3,8
    800041ec:	fb3c95e3          	bne	s9,s3,80004196 <exec+0x1c0>
  sz = sz1;
    800041f0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800041f4:	4a81                	li	s5,0
    800041f6:	a84d                	j	800042a8 <exec+0x2d2>
  sp = sz;
    800041f8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041fa:	4481                	li	s1,0
  ustack[argc] = 0;
    800041fc:	00349793          	slli	a5,s1,0x3
    80004200:	f9078793          	addi	a5,a5,-112
    80004204:	97a2                	add	a5,a5,s0
    80004206:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000420a:	00148693          	addi	a3,s1,1
    8000420e:	068e                	slli	a3,a3,0x3
    80004210:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004214:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004218:	01597663          	bgeu	s2,s5,80004224 <exec+0x24e>
  sz = sz1;
    8000421c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004220:	4a81                	li	s5,0
    80004222:	a059                	j	800042a8 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004224:	e9040613          	addi	a2,s0,-368
    80004228:	85ca                	mv	a1,s2
    8000422a:	855a                	mv	a0,s6
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	8dc080e7          	jalr	-1828(ra) # 80000b08 <copyout>
    80004234:	0a054663          	bltz	a0,800042e0 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004238:	058bb783          	ld	a5,88(s7)
    8000423c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004240:	de843783          	ld	a5,-536(s0)
    80004244:	0007c703          	lbu	a4,0(a5)
    80004248:	cf11                	beqz	a4,80004264 <exec+0x28e>
    8000424a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000424c:	02f00693          	li	a3,47
    80004250:	a039                	j	8000425e <exec+0x288>
      last = s+1;
    80004252:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004256:	0785                	addi	a5,a5,1
    80004258:	fff7c703          	lbu	a4,-1(a5)
    8000425c:	c701                	beqz	a4,80004264 <exec+0x28e>
    if(*s == '/')
    8000425e:	fed71ce3          	bne	a4,a3,80004256 <exec+0x280>
    80004262:	bfc5                	j	80004252 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004264:	4641                	li	a2,16
    80004266:	de843583          	ld	a1,-536(s0)
    8000426a:	158b8513          	addi	a0,s7,344
    8000426e:	ffffc097          	auipc	ra,0xffffc
    80004272:	056080e7          	jalr	86(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004276:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000427a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000427e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004282:	058bb783          	ld	a5,88(s7)
    80004286:	e6843703          	ld	a4,-408(s0)
    8000428a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000428c:	058bb783          	ld	a5,88(s7)
    80004290:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004294:	85ea                	mv	a1,s10
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	d0e080e7          	jalr	-754(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000429e:	0004851b          	sext.w	a0,s1
    800042a2:	bbc1                	j	80004072 <exec+0x9c>
    800042a4:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042a8:	df843583          	ld	a1,-520(s0)
    800042ac:	855a                	mv	a0,s6
    800042ae:	ffffd097          	auipc	ra,0xffffd
    800042b2:	cf6080e7          	jalr	-778(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    800042b6:	da0a94e3          	bnez	s5,8000405e <exec+0x88>
  return -1;
    800042ba:	557d                	li	a0,-1
    800042bc:	bb5d                	j	80004072 <exec+0x9c>
    800042be:	de943c23          	sd	s1,-520(s0)
    800042c2:	b7dd                	j	800042a8 <exec+0x2d2>
    800042c4:	de943c23          	sd	s1,-520(s0)
    800042c8:	b7c5                	j	800042a8 <exec+0x2d2>
    800042ca:	de943c23          	sd	s1,-520(s0)
    800042ce:	bfe9                	j	800042a8 <exec+0x2d2>
  sz = sz1;
    800042d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042d4:	4a81                	li	s5,0
    800042d6:	bfc9                	j	800042a8 <exec+0x2d2>
  sz = sz1;
    800042d8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042dc:	4a81                	li	s5,0
    800042de:	b7e9                	j	800042a8 <exec+0x2d2>
  sz = sz1;
    800042e0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042e4:	4a81                	li	s5,0
    800042e6:	b7c9                	j	800042a8 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042e8:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ec:	e0843783          	ld	a5,-504(s0)
    800042f0:	0017869b          	addiw	a3,a5,1
    800042f4:	e0d43423          	sd	a3,-504(s0)
    800042f8:	e0043783          	ld	a5,-512(s0)
    800042fc:	0387879b          	addiw	a5,a5,56
    80004300:	e8845703          	lhu	a4,-376(s0)
    80004304:	e2e6d3e3          	bge	a3,a4,8000412a <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004308:	2781                	sext.w	a5,a5
    8000430a:	e0f43023          	sd	a5,-512(s0)
    8000430e:	03800713          	li	a4,56
    80004312:	86be                	mv	a3,a5
    80004314:	e1840613          	addi	a2,s0,-488
    80004318:	4581                	li	a1,0
    8000431a:	8556                	mv	a0,s5
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	a76080e7          	jalr	-1418(ra) # 80002d92 <readi>
    80004324:	03800793          	li	a5,56
    80004328:	f6f51ee3          	bne	a0,a5,800042a4 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000432c:	e1842783          	lw	a5,-488(s0)
    80004330:	4705                	li	a4,1
    80004332:	fae79de3          	bne	a5,a4,800042ec <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004336:	e4043603          	ld	a2,-448(s0)
    8000433a:	e3843783          	ld	a5,-456(s0)
    8000433e:	f8f660e3          	bltu	a2,a5,800042be <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004342:	e2843783          	ld	a5,-472(s0)
    80004346:	963e                	add	a2,a2,a5
    80004348:	f6f66ee3          	bltu	a2,a5,800042c4 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000434c:	85a6                	mv	a1,s1
    8000434e:	855a                	mv	a0,s6
    80004350:	ffffc097          	auipc	ra,0xffffc
    80004354:	564080e7          	jalr	1380(ra) # 800008b4 <uvmalloc>
    80004358:	dea43c23          	sd	a0,-520(s0)
    8000435c:	d53d                	beqz	a0,800042ca <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000435e:	e2843c03          	ld	s8,-472(s0)
    80004362:	de043783          	ld	a5,-544(s0)
    80004366:	00fc77b3          	and	a5,s8,a5
    8000436a:	ff9d                	bnez	a5,800042a8 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000436c:	e2042c83          	lw	s9,-480(s0)
    80004370:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004374:	f60b8ae3          	beqz	s7,800042e8 <exec+0x312>
    80004378:	89de                	mv	s3,s7
    8000437a:	4481                	li	s1,0
    8000437c:	b371                	j	80004108 <exec+0x132>

000000008000437e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000437e:	7179                	addi	sp,sp,-48
    80004380:	f406                	sd	ra,40(sp)
    80004382:	f022                	sd	s0,32(sp)
    80004384:	ec26                	sd	s1,24(sp)
    80004386:	e84a                	sd	s2,16(sp)
    80004388:	1800                	addi	s0,sp,48
    8000438a:	892e                	mv	s2,a1
    8000438c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000438e:	fdc40593          	addi	a1,s0,-36
    80004392:	ffffe097          	auipc	ra,0xffffe
    80004396:	b70080e7          	jalr	-1168(ra) # 80001f02 <argint>
    8000439a:	04054063          	bltz	a0,800043da <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000439e:	fdc42703          	lw	a4,-36(s0)
    800043a2:	47bd                	li	a5,15
    800043a4:	02e7ed63          	bltu	a5,a4,800043de <argfd+0x60>
    800043a8:	ffffd097          	auipc	ra,0xffffd
    800043ac:	a9c080e7          	jalr	-1380(ra) # 80000e44 <myproc>
    800043b0:	fdc42703          	lw	a4,-36(s0)
    800043b4:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800043b8:	078e                	slli	a5,a5,0x3
    800043ba:	953e                	add	a0,a0,a5
    800043bc:	611c                	ld	a5,0(a0)
    800043be:	c395                	beqz	a5,800043e2 <argfd+0x64>
    return -1;
  if(pfd)
    800043c0:	00090463          	beqz	s2,800043c8 <argfd+0x4a>
    *pfd = fd;
    800043c4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043c8:	4501                	li	a0,0
  if(pf)
    800043ca:	c091                	beqz	s1,800043ce <argfd+0x50>
    *pf = f;
    800043cc:	e09c                	sd	a5,0(s1)
}
    800043ce:	70a2                	ld	ra,40(sp)
    800043d0:	7402                	ld	s0,32(sp)
    800043d2:	64e2                	ld	s1,24(sp)
    800043d4:	6942                	ld	s2,16(sp)
    800043d6:	6145                	addi	sp,sp,48
    800043d8:	8082                	ret
    return -1;
    800043da:	557d                	li	a0,-1
    800043dc:	bfcd                	j	800043ce <argfd+0x50>
    return -1;
    800043de:	557d                	li	a0,-1
    800043e0:	b7fd                	j	800043ce <argfd+0x50>
    800043e2:	557d                	li	a0,-1
    800043e4:	b7ed                	j	800043ce <argfd+0x50>

00000000800043e6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043e6:	1101                	addi	sp,sp,-32
    800043e8:	ec06                	sd	ra,24(sp)
    800043ea:	e822                	sd	s0,16(sp)
    800043ec:	e426                	sd	s1,8(sp)
    800043ee:	1000                	addi	s0,sp,32
    800043f0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800043f2:	ffffd097          	auipc	ra,0xffffd
    800043f6:	a52080e7          	jalr	-1454(ra) # 80000e44 <myproc>
    800043fa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800043fc:	0d050793          	addi	a5,a0,208
    80004400:	4501                	li	a0,0
    80004402:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004404:	6398                	ld	a4,0(a5)
    80004406:	cb19                	beqz	a4,8000441c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004408:	2505                	addiw	a0,a0,1
    8000440a:	07a1                	addi	a5,a5,8
    8000440c:	fed51ce3          	bne	a0,a3,80004404 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004410:	557d                	li	a0,-1
}
    80004412:	60e2                	ld	ra,24(sp)
    80004414:	6442                	ld	s0,16(sp)
    80004416:	64a2                	ld	s1,8(sp)
    80004418:	6105                	addi	sp,sp,32
    8000441a:	8082                	ret
      p->ofile[fd] = f;
    8000441c:	01a50793          	addi	a5,a0,26
    80004420:	078e                	slli	a5,a5,0x3
    80004422:	963e                	add	a2,a2,a5
    80004424:	e204                	sd	s1,0(a2)
      return fd;
    80004426:	b7f5                	j	80004412 <fdalloc+0x2c>

0000000080004428 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004428:	715d                	addi	sp,sp,-80
    8000442a:	e486                	sd	ra,72(sp)
    8000442c:	e0a2                	sd	s0,64(sp)
    8000442e:	fc26                	sd	s1,56(sp)
    80004430:	f84a                	sd	s2,48(sp)
    80004432:	f44e                	sd	s3,40(sp)
    80004434:	f052                	sd	s4,32(sp)
    80004436:	ec56                	sd	s5,24(sp)
    80004438:	0880                	addi	s0,sp,80
    8000443a:	89ae                	mv	s3,a1
    8000443c:	8ab2                	mv	s5,a2
    8000443e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004440:	fb040593          	addi	a1,s0,-80
    80004444:	fffff097          	auipc	ra,0xfffff
    80004448:	e74080e7          	jalr	-396(ra) # 800032b8 <nameiparent>
    8000444c:	892a                	mv	s2,a0
    8000444e:	12050e63          	beqz	a0,8000458a <create+0x162>
    return 0;

  ilock(dp);
    80004452:	ffffe097          	auipc	ra,0xffffe
    80004456:	68c080e7          	jalr	1676(ra) # 80002ade <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000445a:	4601                	li	a2,0
    8000445c:	fb040593          	addi	a1,s0,-80
    80004460:	854a                	mv	a0,s2
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	b60080e7          	jalr	-1184(ra) # 80002fc2 <dirlookup>
    8000446a:	84aa                	mv	s1,a0
    8000446c:	c921                	beqz	a0,800044bc <create+0x94>
    iunlockput(dp);
    8000446e:	854a                	mv	a0,s2
    80004470:	fffff097          	auipc	ra,0xfffff
    80004474:	8d0080e7          	jalr	-1840(ra) # 80002d40 <iunlockput>
    ilock(ip);
    80004478:	8526                	mv	a0,s1
    8000447a:	ffffe097          	auipc	ra,0xffffe
    8000447e:	664080e7          	jalr	1636(ra) # 80002ade <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004482:	2981                	sext.w	s3,s3
    80004484:	4789                	li	a5,2
    80004486:	02f99463          	bne	s3,a5,800044ae <create+0x86>
    8000448a:	0444d783          	lhu	a5,68(s1)
    8000448e:	37f9                	addiw	a5,a5,-2
    80004490:	17c2                	slli	a5,a5,0x30
    80004492:	93c1                	srli	a5,a5,0x30
    80004494:	4705                	li	a4,1
    80004496:	00f76c63          	bltu	a4,a5,800044ae <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000449a:	8526                	mv	a0,s1
    8000449c:	60a6                	ld	ra,72(sp)
    8000449e:	6406                	ld	s0,64(sp)
    800044a0:	74e2                	ld	s1,56(sp)
    800044a2:	7942                	ld	s2,48(sp)
    800044a4:	79a2                	ld	s3,40(sp)
    800044a6:	7a02                	ld	s4,32(sp)
    800044a8:	6ae2                	ld	s5,24(sp)
    800044aa:	6161                	addi	sp,sp,80
    800044ac:	8082                	ret
    iunlockput(ip);
    800044ae:	8526                	mv	a0,s1
    800044b0:	fffff097          	auipc	ra,0xfffff
    800044b4:	890080e7          	jalr	-1904(ra) # 80002d40 <iunlockput>
    return 0;
    800044b8:	4481                	li	s1,0
    800044ba:	b7c5                	j	8000449a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800044bc:	85ce                	mv	a1,s3
    800044be:	00092503          	lw	a0,0(s2)
    800044c2:	ffffe097          	auipc	ra,0xffffe
    800044c6:	482080e7          	jalr	1154(ra) # 80002944 <ialloc>
    800044ca:	84aa                	mv	s1,a0
    800044cc:	c521                	beqz	a0,80004514 <create+0xec>
  ilock(ip);
    800044ce:	ffffe097          	auipc	ra,0xffffe
    800044d2:	610080e7          	jalr	1552(ra) # 80002ade <ilock>
  ip->major = major;
    800044d6:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800044da:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800044de:	4a05                	li	s4,1
    800044e0:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800044e4:	8526                	mv	a0,s1
    800044e6:	ffffe097          	auipc	ra,0xffffe
    800044ea:	52c080e7          	jalr	1324(ra) # 80002a12 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800044ee:	2981                	sext.w	s3,s3
    800044f0:	03498a63          	beq	s3,s4,80004524 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800044f4:	40d0                	lw	a2,4(s1)
    800044f6:	fb040593          	addi	a1,s0,-80
    800044fa:	854a                	mv	a0,s2
    800044fc:	fffff097          	auipc	ra,0xfffff
    80004500:	cdc080e7          	jalr	-804(ra) # 800031d8 <dirlink>
    80004504:	06054b63          	bltz	a0,8000457a <create+0x152>
  iunlockput(dp);
    80004508:	854a                	mv	a0,s2
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	836080e7          	jalr	-1994(ra) # 80002d40 <iunlockput>
  return ip;
    80004512:	b761                	j	8000449a <create+0x72>
    panic("create: ialloc");
    80004514:	00004517          	auipc	a0,0x4
    80004518:	21c50513          	addi	a0,a0,540 # 80008730 <syscalls+0x2a0>
    8000451c:	00001097          	auipc	ra,0x1
    80004520:	634080e7          	jalr	1588(ra) # 80005b50 <panic>
    dp->nlink++;  // for ".."
    80004524:	04a95783          	lhu	a5,74(s2)
    80004528:	2785                	addiw	a5,a5,1
    8000452a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000452e:	854a                	mv	a0,s2
    80004530:	ffffe097          	auipc	ra,0xffffe
    80004534:	4e2080e7          	jalr	1250(ra) # 80002a12 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004538:	40d0                	lw	a2,4(s1)
    8000453a:	00004597          	auipc	a1,0x4
    8000453e:	20658593          	addi	a1,a1,518 # 80008740 <syscalls+0x2b0>
    80004542:	8526                	mv	a0,s1
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	c94080e7          	jalr	-876(ra) # 800031d8 <dirlink>
    8000454c:	00054f63          	bltz	a0,8000456a <create+0x142>
    80004550:	00492603          	lw	a2,4(s2)
    80004554:	00004597          	auipc	a1,0x4
    80004558:	1f458593          	addi	a1,a1,500 # 80008748 <syscalls+0x2b8>
    8000455c:	8526                	mv	a0,s1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	c7a080e7          	jalr	-902(ra) # 800031d8 <dirlink>
    80004566:	f80557e3          	bgez	a0,800044f4 <create+0xcc>
      panic("create dots");
    8000456a:	00004517          	auipc	a0,0x4
    8000456e:	1e650513          	addi	a0,a0,486 # 80008750 <syscalls+0x2c0>
    80004572:	00001097          	auipc	ra,0x1
    80004576:	5de080e7          	jalr	1502(ra) # 80005b50 <panic>
    panic("create: dirlink");
    8000457a:	00004517          	auipc	a0,0x4
    8000457e:	1e650513          	addi	a0,a0,486 # 80008760 <syscalls+0x2d0>
    80004582:	00001097          	auipc	ra,0x1
    80004586:	5ce080e7          	jalr	1486(ra) # 80005b50 <panic>
    return 0;
    8000458a:	84aa                	mv	s1,a0
    8000458c:	b739                	j	8000449a <create+0x72>

000000008000458e <sys_dup>:
{
    8000458e:	7179                	addi	sp,sp,-48
    80004590:	f406                	sd	ra,40(sp)
    80004592:	f022                	sd	s0,32(sp)
    80004594:	ec26                	sd	s1,24(sp)
    80004596:	e84a                	sd	s2,16(sp)
    80004598:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000459a:	fd840613          	addi	a2,s0,-40
    8000459e:	4581                	li	a1,0
    800045a0:	4501                	li	a0,0
    800045a2:	00000097          	auipc	ra,0x0
    800045a6:	ddc080e7          	jalr	-548(ra) # 8000437e <argfd>
    return -1;
    800045aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045ac:	02054363          	bltz	a0,800045d2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800045b0:	fd843903          	ld	s2,-40(s0)
    800045b4:	854a                	mv	a0,s2
    800045b6:	00000097          	auipc	ra,0x0
    800045ba:	e30080e7          	jalr	-464(ra) # 800043e6 <fdalloc>
    800045be:	84aa                	mv	s1,a0
    return -1;
    800045c0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045c2:	00054863          	bltz	a0,800045d2 <sys_dup+0x44>
  filedup(f);
    800045c6:	854a                	mv	a0,s2
    800045c8:	fffff097          	auipc	ra,0xfffff
    800045cc:	368080e7          	jalr	872(ra) # 80003930 <filedup>
  return fd;
    800045d0:	87a6                	mv	a5,s1
}
    800045d2:	853e                	mv	a0,a5
    800045d4:	70a2                	ld	ra,40(sp)
    800045d6:	7402                	ld	s0,32(sp)
    800045d8:	64e2                	ld	s1,24(sp)
    800045da:	6942                	ld	s2,16(sp)
    800045dc:	6145                	addi	sp,sp,48
    800045de:	8082                	ret

00000000800045e0 <sys_read>:
{
    800045e0:	7179                	addi	sp,sp,-48
    800045e2:	f406                	sd	ra,40(sp)
    800045e4:	f022                	sd	s0,32(sp)
    800045e6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045e8:	fe840613          	addi	a2,s0,-24
    800045ec:	4581                	li	a1,0
    800045ee:	4501                	li	a0,0
    800045f0:	00000097          	auipc	ra,0x0
    800045f4:	d8e080e7          	jalr	-626(ra) # 8000437e <argfd>
    return -1;
    800045f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045fa:	04054163          	bltz	a0,8000463c <sys_read+0x5c>
    800045fe:	fe440593          	addi	a1,s0,-28
    80004602:	4509                	li	a0,2
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	8fe080e7          	jalr	-1794(ra) # 80001f02 <argint>
    return -1;
    8000460c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000460e:	02054763          	bltz	a0,8000463c <sys_read+0x5c>
    80004612:	fd840593          	addi	a1,s0,-40
    80004616:	4505                	li	a0,1
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	90c080e7          	jalr	-1780(ra) # 80001f24 <argaddr>
    return -1;
    80004620:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004622:	00054d63          	bltz	a0,8000463c <sys_read+0x5c>
  return fileread(f, p, n);
    80004626:	fe442603          	lw	a2,-28(s0)
    8000462a:	fd843583          	ld	a1,-40(s0)
    8000462e:	fe843503          	ld	a0,-24(s0)
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	48a080e7          	jalr	1162(ra) # 80003abc <fileread>
    8000463a:	87aa                	mv	a5,a0
}
    8000463c:	853e                	mv	a0,a5
    8000463e:	70a2                	ld	ra,40(sp)
    80004640:	7402                	ld	s0,32(sp)
    80004642:	6145                	addi	sp,sp,48
    80004644:	8082                	ret

0000000080004646 <sys_write>:
{
    80004646:	7179                	addi	sp,sp,-48
    80004648:	f406                	sd	ra,40(sp)
    8000464a:	f022                	sd	s0,32(sp)
    8000464c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000464e:	fe840613          	addi	a2,s0,-24
    80004652:	4581                	li	a1,0
    80004654:	4501                	li	a0,0
    80004656:	00000097          	auipc	ra,0x0
    8000465a:	d28080e7          	jalr	-728(ra) # 8000437e <argfd>
    return -1;
    8000465e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004660:	04054163          	bltz	a0,800046a2 <sys_write+0x5c>
    80004664:	fe440593          	addi	a1,s0,-28
    80004668:	4509                	li	a0,2
    8000466a:	ffffe097          	auipc	ra,0xffffe
    8000466e:	898080e7          	jalr	-1896(ra) # 80001f02 <argint>
    return -1;
    80004672:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004674:	02054763          	bltz	a0,800046a2 <sys_write+0x5c>
    80004678:	fd840593          	addi	a1,s0,-40
    8000467c:	4505                	li	a0,1
    8000467e:	ffffe097          	auipc	ra,0xffffe
    80004682:	8a6080e7          	jalr	-1882(ra) # 80001f24 <argaddr>
    return -1;
    80004686:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004688:	00054d63          	bltz	a0,800046a2 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000468c:	fe442603          	lw	a2,-28(s0)
    80004690:	fd843583          	ld	a1,-40(s0)
    80004694:	fe843503          	ld	a0,-24(s0)
    80004698:	fffff097          	auipc	ra,0xfffff
    8000469c:	4e6080e7          	jalr	1254(ra) # 80003b7e <filewrite>
    800046a0:	87aa                	mv	a5,a0
}
    800046a2:	853e                	mv	a0,a5
    800046a4:	70a2                	ld	ra,40(sp)
    800046a6:	7402                	ld	s0,32(sp)
    800046a8:	6145                	addi	sp,sp,48
    800046aa:	8082                	ret

00000000800046ac <sys_close>:
{
    800046ac:	1101                	addi	sp,sp,-32
    800046ae:	ec06                	sd	ra,24(sp)
    800046b0:	e822                	sd	s0,16(sp)
    800046b2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046b4:	fe040613          	addi	a2,s0,-32
    800046b8:	fec40593          	addi	a1,s0,-20
    800046bc:	4501                	li	a0,0
    800046be:	00000097          	auipc	ra,0x0
    800046c2:	cc0080e7          	jalr	-832(ra) # 8000437e <argfd>
    return -1;
    800046c6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046c8:	02054463          	bltz	a0,800046f0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	778080e7          	jalr	1912(ra) # 80000e44 <myproc>
    800046d4:	fec42783          	lw	a5,-20(s0)
    800046d8:	07e9                	addi	a5,a5,26
    800046da:	078e                	slli	a5,a5,0x3
    800046dc:	953e                	add	a0,a0,a5
    800046de:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800046e2:	fe043503          	ld	a0,-32(s0)
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	29c080e7          	jalr	668(ra) # 80003982 <fileclose>
  return 0;
    800046ee:	4781                	li	a5,0
}
    800046f0:	853e                	mv	a0,a5
    800046f2:	60e2                	ld	ra,24(sp)
    800046f4:	6442                	ld	s0,16(sp)
    800046f6:	6105                	addi	sp,sp,32
    800046f8:	8082                	ret

00000000800046fa <sys_fstat>:
{
    800046fa:	1101                	addi	sp,sp,-32
    800046fc:	ec06                	sd	ra,24(sp)
    800046fe:	e822                	sd	s0,16(sp)
    80004700:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004702:	fe840613          	addi	a2,s0,-24
    80004706:	4581                	li	a1,0
    80004708:	4501                	li	a0,0
    8000470a:	00000097          	auipc	ra,0x0
    8000470e:	c74080e7          	jalr	-908(ra) # 8000437e <argfd>
    return -1;
    80004712:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004714:	02054563          	bltz	a0,8000473e <sys_fstat+0x44>
    80004718:	fe040593          	addi	a1,s0,-32
    8000471c:	4505                	li	a0,1
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	806080e7          	jalr	-2042(ra) # 80001f24 <argaddr>
    return -1;
    80004726:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004728:	00054b63          	bltz	a0,8000473e <sys_fstat+0x44>
  return filestat(f, st);
    8000472c:	fe043583          	ld	a1,-32(s0)
    80004730:	fe843503          	ld	a0,-24(s0)
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	316080e7          	jalr	790(ra) # 80003a4a <filestat>
    8000473c:	87aa                	mv	a5,a0
}
    8000473e:	853e                	mv	a0,a5
    80004740:	60e2                	ld	ra,24(sp)
    80004742:	6442                	ld	s0,16(sp)
    80004744:	6105                	addi	sp,sp,32
    80004746:	8082                	ret

0000000080004748 <sys_link>:
{
    80004748:	7169                	addi	sp,sp,-304
    8000474a:	f606                	sd	ra,296(sp)
    8000474c:	f222                	sd	s0,288(sp)
    8000474e:	ee26                	sd	s1,280(sp)
    80004750:	ea4a                	sd	s2,272(sp)
    80004752:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004754:	08000613          	li	a2,128
    80004758:	ed040593          	addi	a1,s0,-304
    8000475c:	4501                	li	a0,0
    8000475e:	ffffd097          	auipc	ra,0xffffd
    80004762:	7e8080e7          	jalr	2024(ra) # 80001f46 <argstr>
    return -1;
    80004766:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004768:	10054e63          	bltz	a0,80004884 <sys_link+0x13c>
    8000476c:	08000613          	li	a2,128
    80004770:	f5040593          	addi	a1,s0,-176
    80004774:	4505                	li	a0,1
    80004776:	ffffd097          	auipc	ra,0xffffd
    8000477a:	7d0080e7          	jalr	2000(ra) # 80001f46 <argstr>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004780:	10054263          	bltz	a0,80004884 <sys_link+0x13c>
  begin_op();
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	d36080e7          	jalr	-714(ra) # 800034ba <begin_op>
  if((ip = namei(old)) == 0){
    8000478c:	ed040513          	addi	a0,s0,-304
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	b0a080e7          	jalr	-1270(ra) # 8000329a <namei>
    80004798:	84aa                	mv	s1,a0
    8000479a:	c551                	beqz	a0,80004826 <sys_link+0xde>
  ilock(ip);
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	342080e7          	jalr	834(ra) # 80002ade <ilock>
  if(ip->type == T_DIR){
    800047a4:	04449703          	lh	a4,68(s1)
    800047a8:	4785                	li	a5,1
    800047aa:	08f70463          	beq	a4,a5,80004832 <sys_link+0xea>
  ip->nlink++;
    800047ae:	04a4d783          	lhu	a5,74(s1)
    800047b2:	2785                	addiw	a5,a5,1
    800047b4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047b8:	8526                	mv	a0,s1
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	258080e7          	jalr	600(ra) # 80002a12 <iupdate>
  iunlock(ip);
    800047c2:	8526                	mv	a0,s1
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	3dc080e7          	jalr	988(ra) # 80002ba0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047cc:	fd040593          	addi	a1,s0,-48
    800047d0:	f5040513          	addi	a0,s0,-176
    800047d4:	fffff097          	auipc	ra,0xfffff
    800047d8:	ae4080e7          	jalr	-1308(ra) # 800032b8 <nameiparent>
    800047dc:	892a                	mv	s2,a0
    800047de:	c935                	beqz	a0,80004852 <sys_link+0x10a>
  ilock(dp);
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	2fe080e7          	jalr	766(ra) # 80002ade <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047e8:	00092703          	lw	a4,0(s2)
    800047ec:	409c                	lw	a5,0(s1)
    800047ee:	04f71d63          	bne	a4,a5,80004848 <sys_link+0x100>
    800047f2:	40d0                	lw	a2,4(s1)
    800047f4:	fd040593          	addi	a1,s0,-48
    800047f8:	854a                	mv	a0,s2
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	9de080e7          	jalr	-1570(ra) # 800031d8 <dirlink>
    80004802:	04054363          	bltz	a0,80004848 <sys_link+0x100>
  iunlockput(dp);
    80004806:	854a                	mv	a0,s2
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	538080e7          	jalr	1336(ra) # 80002d40 <iunlockput>
  iput(ip);
    80004810:	8526                	mv	a0,s1
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	486080e7          	jalr	1158(ra) # 80002c98 <iput>
  end_op();
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	d1e080e7          	jalr	-738(ra) # 80003538 <end_op>
  return 0;
    80004822:	4781                	li	a5,0
    80004824:	a085                	j	80004884 <sys_link+0x13c>
    end_op();
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	d12080e7          	jalr	-750(ra) # 80003538 <end_op>
    return -1;
    8000482e:	57fd                	li	a5,-1
    80004830:	a891                	j	80004884 <sys_link+0x13c>
    iunlockput(ip);
    80004832:	8526                	mv	a0,s1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	50c080e7          	jalr	1292(ra) # 80002d40 <iunlockput>
    end_op();
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	cfc080e7          	jalr	-772(ra) # 80003538 <end_op>
    return -1;
    80004844:	57fd                	li	a5,-1
    80004846:	a83d                	j	80004884 <sys_link+0x13c>
    iunlockput(dp);
    80004848:	854a                	mv	a0,s2
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	4f6080e7          	jalr	1270(ra) # 80002d40 <iunlockput>
  ilock(ip);
    80004852:	8526                	mv	a0,s1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	28a080e7          	jalr	650(ra) # 80002ade <ilock>
  ip->nlink--;
    8000485c:	04a4d783          	lhu	a5,74(s1)
    80004860:	37fd                	addiw	a5,a5,-1
    80004862:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004866:	8526                	mv	a0,s1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	1aa080e7          	jalr	426(ra) # 80002a12 <iupdate>
  iunlockput(ip);
    80004870:	8526                	mv	a0,s1
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	4ce080e7          	jalr	1230(ra) # 80002d40 <iunlockput>
  end_op();
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	cbe080e7          	jalr	-834(ra) # 80003538 <end_op>
  return -1;
    80004882:	57fd                	li	a5,-1
}
    80004884:	853e                	mv	a0,a5
    80004886:	70b2                	ld	ra,296(sp)
    80004888:	7412                	ld	s0,288(sp)
    8000488a:	64f2                	ld	s1,280(sp)
    8000488c:	6952                	ld	s2,272(sp)
    8000488e:	6155                	addi	sp,sp,304
    80004890:	8082                	ret

0000000080004892 <sys_unlink>:
{
    80004892:	7151                	addi	sp,sp,-240
    80004894:	f586                	sd	ra,232(sp)
    80004896:	f1a2                	sd	s0,224(sp)
    80004898:	eda6                	sd	s1,216(sp)
    8000489a:	e9ca                	sd	s2,208(sp)
    8000489c:	e5ce                	sd	s3,200(sp)
    8000489e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048a0:	08000613          	li	a2,128
    800048a4:	f3040593          	addi	a1,s0,-208
    800048a8:	4501                	li	a0,0
    800048aa:	ffffd097          	auipc	ra,0xffffd
    800048ae:	69c080e7          	jalr	1692(ra) # 80001f46 <argstr>
    800048b2:	18054163          	bltz	a0,80004a34 <sys_unlink+0x1a2>
  begin_op();
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	c04080e7          	jalr	-1020(ra) # 800034ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048be:	fb040593          	addi	a1,s0,-80
    800048c2:	f3040513          	addi	a0,s0,-208
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	9f2080e7          	jalr	-1550(ra) # 800032b8 <nameiparent>
    800048ce:	84aa                	mv	s1,a0
    800048d0:	c979                	beqz	a0,800049a6 <sys_unlink+0x114>
  ilock(dp);
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	20c080e7          	jalr	524(ra) # 80002ade <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048da:	00004597          	auipc	a1,0x4
    800048de:	e6658593          	addi	a1,a1,-410 # 80008740 <syscalls+0x2b0>
    800048e2:	fb040513          	addi	a0,s0,-80
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	6c2080e7          	jalr	1730(ra) # 80002fa8 <namecmp>
    800048ee:	14050a63          	beqz	a0,80004a42 <sys_unlink+0x1b0>
    800048f2:	00004597          	auipc	a1,0x4
    800048f6:	e5658593          	addi	a1,a1,-426 # 80008748 <syscalls+0x2b8>
    800048fa:	fb040513          	addi	a0,s0,-80
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	6aa080e7          	jalr	1706(ra) # 80002fa8 <namecmp>
    80004906:	12050e63          	beqz	a0,80004a42 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000490a:	f2c40613          	addi	a2,s0,-212
    8000490e:	fb040593          	addi	a1,s0,-80
    80004912:	8526                	mv	a0,s1
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	6ae080e7          	jalr	1710(ra) # 80002fc2 <dirlookup>
    8000491c:	892a                	mv	s2,a0
    8000491e:	12050263          	beqz	a0,80004a42 <sys_unlink+0x1b0>
  ilock(ip);
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	1bc080e7          	jalr	444(ra) # 80002ade <ilock>
  if(ip->nlink < 1)
    8000492a:	04a91783          	lh	a5,74(s2)
    8000492e:	08f05263          	blez	a5,800049b2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004932:	04491703          	lh	a4,68(s2)
    80004936:	4785                	li	a5,1
    80004938:	08f70563          	beq	a4,a5,800049c2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000493c:	4641                	li	a2,16
    8000493e:	4581                	li	a1,0
    80004940:	fc040513          	addi	a0,s0,-64
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	836080e7          	jalr	-1994(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000494c:	4741                	li	a4,16
    8000494e:	f2c42683          	lw	a3,-212(s0)
    80004952:	fc040613          	addi	a2,s0,-64
    80004956:	4581                	li	a1,0
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	530080e7          	jalr	1328(ra) # 80002e8a <writei>
    80004962:	47c1                	li	a5,16
    80004964:	0af51563          	bne	a0,a5,80004a0e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004968:	04491703          	lh	a4,68(s2)
    8000496c:	4785                	li	a5,1
    8000496e:	0af70863          	beq	a4,a5,80004a1e <sys_unlink+0x18c>
  iunlockput(dp);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	3cc080e7          	jalr	972(ra) # 80002d40 <iunlockput>
  ip->nlink--;
    8000497c:	04a95783          	lhu	a5,74(s2)
    80004980:	37fd                	addiw	a5,a5,-1
    80004982:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004986:	854a                	mv	a0,s2
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	08a080e7          	jalr	138(ra) # 80002a12 <iupdate>
  iunlockput(ip);
    80004990:	854a                	mv	a0,s2
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	3ae080e7          	jalr	942(ra) # 80002d40 <iunlockput>
  end_op();
    8000499a:	fffff097          	auipc	ra,0xfffff
    8000499e:	b9e080e7          	jalr	-1122(ra) # 80003538 <end_op>
  return 0;
    800049a2:	4501                	li	a0,0
    800049a4:	a84d                	j	80004a56 <sys_unlink+0x1c4>
    end_op();
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	b92080e7          	jalr	-1134(ra) # 80003538 <end_op>
    return -1;
    800049ae:	557d                	li	a0,-1
    800049b0:	a05d                	j	80004a56 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049b2:	00004517          	auipc	a0,0x4
    800049b6:	dbe50513          	addi	a0,a0,-578 # 80008770 <syscalls+0x2e0>
    800049ba:	00001097          	auipc	ra,0x1
    800049be:	196080e7          	jalr	406(ra) # 80005b50 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049c2:	04c92703          	lw	a4,76(s2)
    800049c6:	02000793          	li	a5,32
    800049ca:	f6e7f9e3          	bgeu	a5,a4,8000493c <sys_unlink+0xaa>
    800049ce:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049d2:	4741                	li	a4,16
    800049d4:	86ce                	mv	a3,s3
    800049d6:	f1840613          	addi	a2,s0,-232
    800049da:	4581                	li	a1,0
    800049dc:	854a                	mv	a0,s2
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	3b4080e7          	jalr	948(ra) # 80002d92 <readi>
    800049e6:	47c1                	li	a5,16
    800049e8:	00f51b63          	bne	a0,a5,800049fe <sys_unlink+0x16c>
    if(de.inum != 0)
    800049ec:	f1845783          	lhu	a5,-232(s0)
    800049f0:	e7a1                	bnez	a5,80004a38 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049f2:	29c1                	addiw	s3,s3,16
    800049f4:	04c92783          	lw	a5,76(s2)
    800049f8:	fcf9ede3          	bltu	s3,a5,800049d2 <sys_unlink+0x140>
    800049fc:	b781                	j	8000493c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800049fe:	00004517          	auipc	a0,0x4
    80004a02:	d8a50513          	addi	a0,a0,-630 # 80008788 <syscalls+0x2f8>
    80004a06:	00001097          	auipc	ra,0x1
    80004a0a:	14a080e7          	jalr	330(ra) # 80005b50 <panic>
    panic("unlink: writei");
    80004a0e:	00004517          	auipc	a0,0x4
    80004a12:	d9250513          	addi	a0,a0,-622 # 800087a0 <syscalls+0x310>
    80004a16:	00001097          	auipc	ra,0x1
    80004a1a:	13a080e7          	jalr	314(ra) # 80005b50 <panic>
    dp->nlink--;
    80004a1e:	04a4d783          	lhu	a5,74(s1)
    80004a22:	37fd                	addiw	a5,a5,-1
    80004a24:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	fe8080e7          	jalr	-24(ra) # 80002a12 <iupdate>
    80004a32:	b781                	j	80004972 <sys_unlink+0xe0>
    return -1;
    80004a34:	557d                	li	a0,-1
    80004a36:	a005                	j	80004a56 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	306080e7          	jalr	774(ra) # 80002d40 <iunlockput>
  iunlockput(dp);
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	2fc080e7          	jalr	764(ra) # 80002d40 <iunlockput>
  end_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	aec080e7          	jalr	-1300(ra) # 80003538 <end_op>
  return -1;
    80004a54:	557d                	li	a0,-1
}
    80004a56:	70ae                	ld	ra,232(sp)
    80004a58:	740e                	ld	s0,224(sp)
    80004a5a:	64ee                	ld	s1,216(sp)
    80004a5c:	694e                	ld	s2,208(sp)
    80004a5e:	69ae                	ld	s3,200(sp)
    80004a60:	616d                	addi	sp,sp,240
    80004a62:	8082                	ret

0000000080004a64 <sys_open>:

uint64
sys_open(void)
{
    80004a64:	7131                	addi	sp,sp,-192
    80004a66:	fd06                	sd	ra,184(sp)
    80004a68:	f922                	sd	s0,176(sp)
    80004a6a:	f526                	sd	s1,168(sp)
    80004a6c:	f14a                	sd	s2,160(sp)
    80004a6e:	ed4e                	sd	s3,152(sp)
    80004a70:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a72:	08000613          	li	a2,128
    80004a76:	f5040593          	addi	a1,s0,-176
    80004a7a:	4501                	li	a0,0
    80004a7c:	ffffd097          	auipc	ra,0xffffd
    80004a80:	4ca080e7          	jalr	1226(ra) # 80001f46 <argstr>
    return -1;
    80004a84:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a86:	0c054163          	bltz	a0,80004b48 <sys_open+0xe4>
    80004a8a:	f4c40593          	addi	a1,s0,-180
    80004a8e:	4505                	li	a0,1
    80004a90:	ffffd097          	auipc	ra,0xffffd
    80004a94:	472080e7          	jalr	1138(ra) # 80001f02 <argint>
    80004a98:	0a054863          	bltz	a0,80004b48 <sys_open+0xe4>

  begin_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	a1e080e7          	jalr	-1506(ra) # 800034ba <begin_op>

  if(omode & O_CREATE){
    80004aa4:	f4c42783          	lw	a5,-180(s0)
    80004aa8:	2007f793          	andi	a5,a5,512
    80004aac:	cbdd                	beqz	a5,80004b62 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004aae:	4681                	li	a3,0
    80004ab0:	4601                	li	a2,0
    80004ab2:	4589                	li	a1,2
    80004ab4:	f5040513          	addi	a0,s0,-176
    80004ab8:	00000097          	auipc	ra,0x0
    80004abc:	970080e7          	jalr	-1680(ra) # 80004428 <create>
    80004ac0:	892a                	mv	s2,a0
    if(ip == 0){
    80004ac2:	c959                	beqz	a0,80004b58 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ac4:	04491703          	lh	a4,68(s2)
    80004ac8:	478d                	li	a5,3
    80004aca:	00f71763          	bne	a4,a5,80004ad8 <sys_open+0x74>
    80004ace:	04695703          	lhu	a4,70(s2)
    80004ad2:	47a5                	li	a5,9
    80004ad4:	0ce7ec63          	bltu	a5,a4,80004bac <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	dee080e7          	jalr	-530(ra) # 800038c6 <filealloc>
    80004ae0:	89aa                	mv	s3,a0
    80004ae2:	10050263          	beqz	a0,80004be6 <sys_open+0x182>
    80004ae6:	00000097          	auipc	ra,0x0
    80004aea:	900080e7          	jalr	-1792(ra) # 800043e6 <fdalloc>
    80004aee:	84aa                	mv	s1,a0
    80004af0:	0e054663          	bltz	a0,80004bdc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004af4:	04491703          	lh	a4,68(s2)
    80004af8:	478d                	li	a5,3
    80004afa:	0cf70463          	beq	a4,a5,80004bc2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004afe:	4789                	li	a5,2
    80004b00:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b04:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b08:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b0c:	f4c42783          	lw	a5,-180(s0)
    80004b10:	0017c713          	xori	a4,a5,1
    80004b14:	8b05                	andi	a4,a4,1
    80004b16:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b1a:	0037f713          	andi	a4,a5,3
    80004b1e:	00e03733          	snez	a4,a4
    80004b22:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b26:	4007f793          	andi	a5,a5,1024
    80004b2a:	c791                	beqz	a5,80004b36 <sys_open+0xd2>
    80004b2c:	04491703          	lh	a4,68(s2)
    80004b30:	4789                	li	a5,2
    80004b32:	08f70f63          	beq	a4,a5,80004bd0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b36:	854a                	mv	a0,s2
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	068080e7          	jalr	104(ra) # 80002ba0 <iunlock>
  end_op();
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	9f8080e7          	jalr	-1544(ra) # 80003538 <end_op>

  return fd;
}
    80004b48:	8526                	mv	a0,s1
    80004b4a:	70ea                	ld	ra,184(sp)
    80004b4c:	744a                	ld	s0,176(sp)
    80004b4e:	74aa                	ld	s1,168(sp)
    80004b50:	790a                	ld	s2,160(sp)
    80004b52:	69ea                	ld	s3,152(sp)
    80004b54:	6129                	addi	sp,sp,192
    80004b56:	8082                	ret
      end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	9e0080e7          	jalr	-1568(ra) # 80003538 <end_op>
      return -1;
    80004b60:	b7e5                	j	80004b48 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b62:	f5040513          	addi	a0,s0,-176
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	734080e7          	jalr	1844(ra) # 8000329a <namei>
    80004b6e:	892a                	mv	s2,a0
    80004b70:	c905                	beqz	a0,80004ba0 <sys_open+0x13c>
    ilock(ip);
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	f6c080e7          	jalr	-148(ra) # 80002ade <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b7a:	04491703          	lh	a4,68(s2)
    80004b7e:	4785                	li	a5,1
    80004b80:	f4f712e3          	bne	a4,a5,80004ac4 <sys_open+0x60>
    80004b84:	f4c42783          	lw	a5,-180(s0)
    80004b88:	dba1                	beqz	a5,80004ad8 <sys_open+0x74>
      iunlockput(ip);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	1b4080e7          	jalr	436(ra) # 80002d40 <iunlockput>
      end_op();
    80004b94:	fffff097          	auipc	ra,0xfffff
    80004b98:	9a4080e7          	jalr	-1628(ra) # 80003538 <end_op>
      return -1;
    80004b9c:	54fd                	li	s1,-1
    80004b9e:	b76d                	j	80004b48 <sys_open+0xe4>
      end_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	998080e7          	jalr	-1640(ra) # 80003538 <end_op>
      return -1;
    80004ba8:	54fd                	li	s1,-1
    80004baa:	bf79                	j	80004b48 <sys_open+0xe4>
    iunlockput(ip);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	192080e7          	jalr	402(ra) # 80002d40 <iunlockput>
    end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	982080e7          	jalr	-1662(ra) # 80003538 <end_op>
    return -1;
    80004bbe:	54fd                	li	s1,-1
    80004bc0:	b761                	j	80004b48 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bc2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bc6:	04691783          	lh	a5,70(s2)
    80004bca:	02f99223          	sh	a5,36(s3)
    80004bce:	bf2d                	j	80004b08 <sys_open+0xa4>
    itrunc(ip);
    80004bd0:	854a                	mv	a0,s2
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	01a080e7          	jalr	26(ra) # 80002bec <itrunc>
    80004bda:	bfb1                	j	80004b36 <sys_open+0xd2>
      fileclose(f);
    80004bdc:	854e                	mv	a0,s3
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	da4080e7          	jalr	-604(ra) # 80003982 <fileclose>
    iunlockput(ip);
    80004be6:	854a                	mv	a0,s2
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	158080e7          	jalr	344(ra) # 80002d40 <iunlockput>
    end_op();
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	948080e7          	jalr	-1720(ra) # 80003538 <end_op>
    return -1;
    80004bf8:	54fd                	li	s1,-1
    80004bfa:	b7b9                	j	80004b48 <sys_open+0xe4>

0000000080004bfc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004bfc:	7175                	addi	sp,sp,-144
    80004bfe:	e506                	sd	ra,136(sp)
    80004c00:	e122                	sd	s0,128(sp)
    80004c02:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	8b6080e7          	jalr	-1866(ra) # 800034ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c0c:	08000613          	li	a2,128
    80004c10:	f7040593          	addi	a1,s0,-144
    80004c14:	4501                	li	a0,0
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	330080e7          	jalr	816(ra) # 80001f46 <argstr>
    80004c1e:	02054963          	bltz	a0,80004c50 <sys_mkdir+0x54>
    80004c22:	4681                	li	a3,0
    80004c24:	4601                	li	a2,0
    80004c26:	4585                	li	a1,1
    80004c28:	f7040513          	addi	a0,s0,-144
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	7fc080e7          	jalr	2044(ra) # 80004428 <create>
    80004c34:	cd11                	beqz	a0,80004c50 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	10a080e7          	jalr	266(ra) # 80002d40 <iunlockput>
  end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	8fa080e7          	jalr	-1798(ra) # 80003538 <end_op>
  return 0;
    80004c46:	4501                	li	a0,0
}
    80004c48:	60aa                	ld	ra,136(sp)
    80004c4a:	640a                	ld	s0,128(sp)
    80004c4c:	6149                	addi	sp,sp,144
    80004c4e:	8082                	ret
    end_op();
    80004c50:	fffff097          	auipc	ra,0xfffff
    80004c54:	8e8080e7          	jalr	-1816(ra) # 80003538 <end_op>
    return -1;
    80004c58:	557d                	li	a0,-1
    80004c5a:	b7fd                	j	80004c48 <sys_mkdir+0x4c>

0000000080004c5c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c5c:	7135                	addi	sp,sp,-160
    80004c5e:	ed06                	sd	ra,152(sp)
    80004c60:	e922                	sd	s0,144(sp)
    80004c62:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	856080e7          	jalr	-1962(ra) # 800034ba <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c6c:	08000613          	li	a2,128
    80004c70:	f7040593          	addi	a1,s0,-144
    80004c74:	4501                	li	a0,0
    80004c76:	ffffd097          	auipc	ra,0xffffd
    80004c7a:	2d0080e7          	jalr	720(ra) # 80001f46 <argstr>
    80004c7e:	04054a63          	bltz	a0,80004cd2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004c82:	f6c40593          	addi	a1,s0,-148
    80004c86:	4505                	li	a0,1
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	27a080e7          	jalr	634(ra) # 80001f02 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c90:	04054163          	bltz	a0,80004cd2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c94:	f6840593          	addi	a1,s0,-152
    80004c98:	4509                	li	a0,2
    80004c9a:	ffffd097          	auipc	ra,0xffffd
    80004c9e:	268080e7          	jalr	616(ra) # 80001f02 <argint>
     argint(1, &major) < 0 ||
    80004ca2:	02054863          	bltz	a0,80004cd2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ca6:	f6841683          	lh	a3,-152(s0)
    80004caa:	f6c41603          	lh	a2,-148(s0)
    80004cae:	458d                	li	a1,3
    80004cb0:	f7040513          	addi	a0,s0,-144
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	774080e7          	jalr	1908(ra) # 80004428 <create>
     argint(2, &minor) < 0 ||
    80004cbc:	c919                	beqz	a0,80004cd2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	082080e7          	jalr	130(ra) # 80002d40 <iunlockput>
  end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	872080e7          	jalr	-1934(ra) # 80003538 <end_op>
  return 0;
    80004cce:	4501                	li	a0,0
    80004cd0:	a031                	j	80004cdc <sys_mknod+0x80>
    end_op();
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	866080e7          	jalr	-1946(ra) # 80003538 <end_op>
    return -1;
    80004cda:	557d                	li	a0,-1
}
    80004cdc:	60ea                	ld	ra,152(sp)
    80004cde:	644a                	ld	s0,144(sp)
    80004ce0:	610d                	addi	sp,sp,160
    80004ce2:	8082                	ret

0000000080004ce4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ce4:	7135                	addi	sp,sp,-160
    80004ce6:	ed06                	sd	ra,152(sp)
    80004ce8:	e922                	sd	s0,144(sp)
    80004cea:	e526                	sd	s1,136(sp)
    80004cec:	e14a                	sd	s2,128(sp)
    80004cee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cf0:	ffffc097          	auipc	ra,0xffffc
    80004cf4:	154080e7          	jalr	340(ra) # 80000e44 <myproc>
    80004cf8:	892a                	mv	s2,a0
  
  begin_op();
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	7c0080e7          	jalr	1984(ra) # 800034ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d02:	08000613          	li	a2,128
    80004d06:	f6040593          	addi	a1,s0,-160
    80004d0a:	4501                	li	a0,0
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	23a080e7          	jalr	570(ra) # 80001f46 <argstr>
    80004d14:	04054b63          	bltz	a0,80004d6a <sys_chdir+0x86>
    80004d18:	f6040513          	addi	a0,s0,-160
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	57e080e7          	jalr	1406(ra) # 8000329a <namei>
    80004d24:	84aa                	mv	s1,a0
    80004d26:	c131                	beqz	a0,80004d6a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	db6080e7          	jalr	-586(ra) # 80002ade <ilock>
  if(ip->type != T_DIR){
    80004d30:	04449703          	lh	a4,68(s1)
    80004d34:	4785                	li	a5,1
    80004d36:	04f71063          	bne	a4,a5,80004d76 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d3a:	8526                	mv	a0,s1
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	e64080e7          	jalr	-412(ra) # 80002ba0 <iunlock>
  iput(p->cwd);
    80004d44:	15093503          	ld	a0,336(s2)
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	f50080e7          	jalr	-176(ra) # 80002c98 <iput>
  end_op();
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	7e8080e7          	jalr	2024(ra) # 80003538 <end_op>
  p->cwd = ip;
    80004d58:	14993823          	sd	s1,336(s2)
  return 0;
    80004d5c:	4501                	li	a0,0
}
    80004d5e:	60ea                	ld	ra,152(sp)
    80004d60:	644a                	ld	s0,144(sp)
    80004d62:	64aa                	ld	s1,136(sp)
    80004d64:	690a                	ld	s2,128(sp)
    80004d66:	610d                	addi	sp,sp,160
    80004d68:	8082                	ret
    end_op();
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	7ce080e7          	jalr	1998(ra) # 80003538 <end_op>
    return -1;
    80004d72:	557d                	li	a0,-1
    80004d74:	b7ed                	j	80004d5e <sys_chdir+0x7a>
    iunlockput(ip);
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	fc8080e7          	jalr	-56(ra) # 80002d40 <iunlockput>
    end_op();
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	7b8080e7          	jalr	1976(ra) # 80003538 <end_op>
    return -1;
    80004d88:	557d                	li	a0,-1
    80004d8a:	bfd1                	j	80004d5e <sys_chdir+0x7a>

0000000080004d8c <sys_exec>:

uint64
sys_exec(void)
{
    80004d8c:	7145                	addi	sp,sp,-464
    80004d8e:	e786                	sd	ra,456(sp)
    80004d90:	e3a2                	sd	s0,448(sp)
    80004d92:	ff26                	sd	s1,440(sp)
    80004d94:	fb4a                	sd	s2,432(sp)
    80004d96:	f74e                	sd	s3,424(sp)
    80004d98:	f352                	sd	s4,416(sp)
    80004d9a:	ef56                	sd	s5,408(sp)
    80004d9c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d9e:	08000613          	li	a2,128
    80004da2:	f4040593          	addi	a1,s0,-192
    80004da6:	4501                	li	a0,0
    80004da8:	ffffd097          	auipc	ra,0xffffd
    80004dac:	19e080e7          	jalr	414(ra) # 80001f46 <argstr>
    return -1;
    80004db0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004db2:	0c054b63          	bltz	a0,80004e88 <sys_exec+0xfc>
    80004db6:	e3840593          	addi	a1,s0,-456
    80004dba:	4505                	li	a0,1
    80004dbc:	ffffd097          	auipc	ra,0xffffd
    80004dc0:	168080e7          	jalr	360(ra) # 80001f24 <argaddr>
    80004dc4:	0c054263          	bltz	a0,80004e88 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004dc8:	10000613          	li	a2,256
    80004dcc:	4581                	li	a1,0
    80004dce:	e4040513          	addi	a0,s0,-448
    80004dd2:	ffffb097          	auipc	ra,0xffffb
    80004dd6:	3a8080e7          	jalr	936(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dda:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004dde:	89a6                	mv	s3,s1
    80004de0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004de2:	02000a13          	li	s4,32
    80004de6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dea:	00391513          	slli	a0,s2,0x3
    80004dee:	e3040593          	addi	a1,s0,-464
    80004df2:	e3843783          	ld	a5,-456(s0)
    80004df6:	953e                	add	a0,a0,a5
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	070080e7          	jalr	112(ra) # 80001e68 <fetchaddr>
    80004e00:	02054a63          	bltz	a0,80004e34 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e04:	e3043783          	ld	a5,-464(s0)
    80004e08:	c3b9                	beqz	a5,80004e4e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e0a:	ffffb097          	auipc	ra,0xffffb
    80004e0e:	310080e7          	jalr	784(ra) # 8000011a <kalloc>
    80004e12:	85aa                	mv	a1,a0
    80004e14:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e18:	cd11                	beqz	a0,80004e34 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e1a:	6605                	lui	a2,0x1
    80004e1c:	e3043503          	ld	a0,-464(s0)
    80004e20:	ffffd097          	auipc	ra,0xffffd
    80004e24:	09a080e7          	jalr	154(ra) # 80001eba <fetchstr>
    80004e28:	00054663          	bltz	a0,80004e34 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e2c:	0905                	addi	s2,s2,1
    80004e2e:	09a1                	addi	s3,s3,8
    80004e30:	fb491be3          	bne	s2,s4,80004de6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e34:	f4040913          	addi	s2,s0,-192
    80004e38:	6088                	ld	a0,0(s1)
    80004e3a:	c531                	beqz	a0,80004e86 <sys_exec+0xfa>
    kfree(argv[i]);
    80004e3c:	ffffb097          	auipc	ra,0xffffb
    80004e40:	1e0080e7          	jalr	480(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e44:	04a1                	addi	s1,s1,8
    80004e46:	ff2499e3          	bne	s1,s2,80004e38 <sys_exec+0xac>
  return -1;
    80004e4a:	597d                	li	s2,-1
    80004e4c:	a835                	j	80004e88 <sys_exec+0xfc>
      argv[i] = 0;
    80004e4e:	0a8e                	slli	s5,s5,0x3
    80004e50:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004e54:	00878ab3          	add	s5,a5,s0
    80004e58:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e5c:	e4040593          	addi	a1,s0,-448
    80004e60:	f4040513          	addi	a0,s0,-192
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	172080e7          	jalr	370(ra) # 80003fd6 <exec>
    80004e6c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e6e:	f4040993          	addi	s3,s0,-192
    80004e72:	6088                	ld	a0,0(s1)
    80004e74:	c911                	beqz	a0,80004e88 <sys_exec+0xfc>
    kfree(argv[i]);
    80004e76:	ffffb097          	auipc	ra,0xffffb
    80004e7a:	1a6080e7          	jalr	422(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e7e:	04a1                	addi	s1,s1,8
    80004e80:	ff3499e3          	bne	s1,s3,80004e72 <sys_exec+0xe6>
    80004e84:	a011                	j	80004e88 <sys_exec+0xfc>
  return -1;
    80004e86:	597d                	li	s2,-1
}
    80004e88:	854a                	mv	a0,s2
    80004e8a:	60be                	ld	ra,456(sp)
    80004e8c:	641e                	ld	s0,448(sp)
    80004e8e:	74fa                	ld	s1,440(sp)
    80004e90:	795a                	ld	s2,432(sp)
    80004e92:	79ba                	ld	s3,424(sp)
    80004e94:	7a1a                	ld	s4,416(sp)
    80004e96:	6afa                	ld	s5,408(sp)
    80004e98:	6179                	addi	sp,sp,464
    80004e9a:	8082                	ret

0000000080004e9c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e9c:	7139                	addi	sp,sp,-64
    80004e9e:	fc06                	sd	ra,56(sp)
    80004ea0:	f822                	sd	s0,48(sp)
    80004ea2:	f426                	sd	s1,40(sp)
    80004ea4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ea6:	ffffc097          	auipc	ra,0xffffc
    80004eaa:	f9e080e7          	jalr	-98(ra) # 80000e44 <myproc>
    80004eae:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004eb0:	fd840593          	addi	a1,s0,-40
    80004eb4:	4501                	li	a0,0
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	06e080e7          	jalr	110(ra) # 80001f24 <argaddr>
    return -1;
    80004ebe:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004ec0:	0e054063          	bltz	a0,80004fa0 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004ec4:	fc840593          	addi	a1,s0,-56
    80004ec8:	fd040513          	addi	a0,s0,-48
    80004ecc:	fffff097          	auipc	ra,0xfffff
    80004ed0:	de6080e7          	jalr	-538(ra) # 80003cb2 <pipealloc>
    return -1;
    80004ed4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ed6:	0c054563          	bltz	a0,80004fa0 <sys_pipe+0x104>
  fd0 = -1;
    80004eda:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ede:	fd043503          	ld	a0,-48(s0)
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	504080e7          	jalr	1284(ra) # 800043e6 <fdalloc>
    80004eea:	fca42223          	sw	a0,-60(s0)
    80004eee:	08054c63          	bltz	a0,80004f86 <sys_pipe+0xea>
    80004ef2:	fc843503          	ld	a0,-56(s0)
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	4f0080e7          	jalr	1264(ra) # 800043e6 <fdalloc>
    80004efe:	fca42023          	sw	a0,-64(s0)
    80004f02:	06054963          	bltz	a0,80004f74 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f06:	4691                	li	a3,4
    80004f08:	fc440613          	addi	a2,s0,-60
    80004f0c:	fd843583          	ld	a1,-40(s0)
    80004f10:	68a8                	ld	a0,80(s1)
    80004f12:	ffffc097          	auipc	ra,0xffffc
    80004f16:	bf6080e7          	jalr	-1034(ra) # 80000b08 <copyout>
    80004f1a:	02054063          	bltz	a0,80004f3a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f1e:	4691                	li	a3,4
    80004f20:	fc040613          	addi	a2,s0,-64
    80004f24:	fd843583          	ld	a1,-40(s0)
    80004f28:	0591                	addi	a1,a1,4
    80004f2a:	68a8                	ld	a0,80(s1)
    80004f2c:	ffffc097          	auipc	ra,0xffffc
    80004f30:	bdc080e7          	jalr	-1060(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f34:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f36:	06055563          	bgez	a0,80004fa0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f3a:	fc442783          	lw	a5,-60(s0)
    80004f3e:	07e9                	addi	a5,a5,26
    80004f40:	078e                	slli	a5,a5,0x3
    80004f42:	97a6                	add	a5,a5,s1
    80004f44:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f48:	fc042783          	lw	a5,-64(s0)
    80004f4c:	07e9                	addi	a5,a5,26
    80004f4e:	078e                	slli	a5,a5,0x3
    80004f50:	00f48533          	add	a0,s1,a5
    80004f54:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f58:	fd043503          	ld	a0,-48(s0)
    80004f5c:	fffff097          	auipc	ra,0xfffff
    80004f60:	a26080e7          	jalr	-1498(ra) # 80003982 <fileclose>
    fileclose(wf);
    80004f64:	fc843503          	ld	a0,-56(s0)
    80004f68:	fffff097          	auipc	ra,0xfffff
    80004f6c:	a1a080e7          	jalr	-1510(ra) # 80003982 <fileclose>
    return -1;
    80004f70:	57fd                	li	a5,-1
    80004f72:	a03d                	j	80004fa0 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004f74:	fc442783          	lw	a5,-60(s0)
    80004f78:	0007c763          	bltz	a5,80004f86 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004f7c:	07e9                	addi	a5,a5,26
    80004f7e:	078e                	slli	a5,a5,0x3
    80004f80:	97a6                	add	a5,a5,s1
    80004f82:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f86:	fd043503          	ld	a0,-48(s0)
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	9f8080e7          	jalr	-1544(ra) # 80003982 <fileclose>
    fileclose(wf);
    80004f92:	fc843503          	ld	a0,-56(s0)
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	9ec080e7          	jalr	-1556(ra) # 80003982 <fileclose>
    return -1;
    80004f9e:	57fd                	li	a5,-1
}
    80004fa0:	853e                	mv	a0,a5
    80004fa2:	70e2                	ld	ra,56(sp)
    80004fa4:	7442                	ld	s0,48(sp)
    80004fa6:	74a2                	ld	s1,40(sp)
    80004fa8:	6121                	addi	sp,sp,64
    80004faa:	8082                	ret
    80004fac:	0000                	unimp
	...

0000000080004fb0 <kernelvec>:
    80004fb0:	7111                	addi	sp,sp,-256
    80004fb2:	e006                	sd	ra,0(sp)
    80004fb4:	e40a                	sd	sp,8(sp)
    80004fb6:	e80e                	sd	gp,16(sp)
    80004fb8:	ec12                	sd	tp,24(sp)
    80004fba:	f016                	sd	t0,32(sp)
    80004fbc:	f41a                	sd	t1,40(sp)
    80004fbe:	f81e                	sd	t2,48(sp)
    80004fc0:	fc22                	sd	s0,56(sp)
    80004fc2:	e0a6                	sd	s1,64(sp)
    80004fc4:	e4aa                	sd	a0,72(sp)
    80004fc6:	e8ae                	sd	a1,80(sp)
    80004fc8:	ecb2                	sd	a2,88(sp)
    80004fca:	f0b6                	sd	a3,96(sp)
    80004fcc:	f4ba                	sd	a4,104(sp)
    80004fce:	f8be                	sd	a5,112(sp)
    80004fd0:	fcc2                	sd	a6,120(sp)
    80004fd2:	e146                	sd	a7,128(sp)
    80004fd4:	e54a                	sd	s2,136(sp)
    80004fd6:	e94e                	sd	s3,144(sp)
    80004fd8:	ed52                	sd	s4,152(sp)
    80004fda:	f156                	sd	s5,160(sp)
    80004fdc:	f55a                	sd	s6,168(sp)
    80004fde:	f95e                	sd	s7,176(sp)
    80004fe0:	fd62                	sd	s8,184(sp)
    80004fe2:	e1e6                	sd	s9,192(sp)
    80004fe4:	e5ea                	sd	s10,200(sp)
    80004fe6:	e9ee                	sd	s11,208(sp)
    80004fe8:	edf2                	sd	t3,216(sp)
    80004fea:	f1f6                	sd	t4,224(sp)
    80004fec:	f5fa                	sd	t5,232(sp)
    80004fee:	f9fe                	sd	t6,240(sp)
    80004ff0:	d45fc0ef          	jal	ra,80001d34 <kerneltrap>
    80004ff4:	6082                	ld	ra,0(sp)
    80004ff6:	6122                	ld	sp,8(sp)
    80004ff8:	61c2                	ld	gp,16(sp)
    80004ffa:	7282                	ld	t0,32(sp)
    80004ffc:	7322                	ld	t1,40(sp)
    80004ffe:	73c2                	ld	t2,48(sp)
    80005000:	7462                	ld	s0,56(sp)
    80005002:	6486                	ld	s1,64(sp)
    80005004:	6526                	ld	a0,72(sp)
    80005006:	65c6                	ld	a1,80(sp)
    80005008:	6666                	ld	a2,88(sp)
    8000500a:	7686                	ld	a3,96(sp)
    8000500c:	7726                	ld	a4,104(sp)
    8000500e:	77c6                	ld	a5,112(sp)
    80005010:	7866                	ld	a6,120(sp)
    80005012:	688a                	ld	a7,128(sp)
    80005014:	692a                	ld	s2,136(sp)
    80005016:	69ca                	ld	s3,144(sp)
    80005018:	6a6a                	ld	s4,152(sp)
    8000501a:	7a8a                	ld	s5,160(sp)
    8000501c:	7b2a                	ld	s6,168(sp)
    8000501e:	7bca                	ld	s7,176(sp)
    80005020:	7c6a                	ld	s8,184(sp)
    80005022:	6c8e                	ld	s9,192(sp)
    80005024:	6d2e                	ld	s10,200(sp)
    80005026:	6dce                	ld	s11,208(sp)
    80005028:	6e6e                	ld	t3,216(sp)
    8000502a:	7e8e                	ld	t4,224(sp)
    8000502c:	7f2e                	ld	t5,232(sp)
    8000502e:	7fce                	ld	t6,240(sp)
    80005030:	6111                	addi	sp,sp,256
    80005032:	10200073          	sret
    80005036:	00000013          	nop
    8000503a:	00000013          	nop
    8000503e:	0001                	nop

0000000080005040 <timervec>:
    80005040:	34051573          	csrrw	a0,mscratch,a0
    80005044:	e10c                	sd	a1,0(a0)
    80005046:	e510                	sd	a2,8(a0)
    80005048:	e914                	sd	a3,16(a0)
    8000504a:	6d0c                	ld	a1,24(a0)
    8000504c:	7110                	ld	a2,32(a0)
    8000504e:	6194                	ld	a3,0(a1)
    80005050:	96b2                	add	a3,a3,a2
    80005052:	e194                	sd	a3,0(a1)
    80005054:	4589                	li	a1,2
    80005056:	14459073          	csrw	sip,a1
    8000505a:	6914                	ld	a3,16(a0)
    8000505c:	6510                	ld	a2,8(a0)
    8000505e:	610c                	ld	a1,0(a0)
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	30200073          	mret
	...

000000008000506a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000506a:	1141                	addi	sp,sp,-16
    8000506c:	e422                	sd	s0,8(sp)
    8000506e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005070:	0c0007b7          	lui	a5,0xc000
    80005074:	4705                	li	a4,1
    80005076:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005078:	c3d8                	sw	a4,4(a5)
}
    8000507a:	6422                	ld	s0,8(sp)
    8000507c:	0141                	addi	sp,sp,16
    8000507e:	8082                	ret

0000000080005080 <plicinithart>:

void
plicinithart(void)
{
    80005080:	1141                	addi	sp,sp,-16
    80005082:	e406                	sd	ra,8(sp)
    80005084:	e022                	sd	s0,0(sp)
    80005086:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	d90080e7          	jalr	-624(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005090:	0085171b          	slliw	a4,a0,0x8
    80005094:	0c0027b7          	lui	a5,0xc002
    80005098:	97ba                	add	a5,a5,a4
    8000509a:	40200713          	li	a4,1026
    8000509e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050a2:	00d5151b          	slliw	a0,a0,0xd
    800050a6:	0c2017b7          	lui	a5,0xc201
    800050aa:	97aa                	add	a5,a5,a0
    800050ac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050b0:	60a2                	ld	ra,8(sp)
    800050b2:	6402                	ld	s0,0(sp)
    800050b4:	0141                	addi	sp,sp,16
    800050b6:	8082                	ret

00000000800050b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e406                	sd	ra,8(sp)
    800050bc:	e022                	sd	s0,0(sp)
    800050be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d58080e7          	jalr	-680(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050c8:	00d5151b          	slliw	a0,a0,0xd
    800050cc:	0c2017b7          	lui	a5,0xc201
    800050d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050d2:	43c8                	lw	a0,4(a5)
    800050d4:	60a2                	ld	ra,8(sp)
    800050d6:	6402                	ld	s0,0(sp)
    800050d8:	0141                	addi	sp,sp,16
    800050da:	8082                	ret

00000000800050dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050dc:	1101                	addi	sp,sp,-32
    800050de:	ec06                	sd	ra,24(sp)
    800050e0:	e822                	sd	s0,16(sp)
    800050e2:	e426                	sd	s1,8(sp)
    800050e4:	1000                	addi	s0,sp,32
    800050e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d30080e7          	jalr	-720(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050f0:	00d5151b          	slliw	a0,a0,0xd
    800050f4:	0c2017b7          	lui	a5,0xc201
    800050f8:	97aa                	add	a5,a5,a0
    800050fa:	c3c4                	sw	s1,4(a5)
}
    800050fc:	60e2                	ld	ra,24(sp)
    800050fe:	6442                	ld	s0,16(sp)
    80005100:	64a2                	ld	s1,8(sp)
    80005102:	6105                	addi	sp,sp,32
    80005104:	8082                	ret

0000000080005106 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005106:	1141                	addi	sp,sp,-16
    80005108:	e406                	sd	ra,8(sp)
    8000510a:	e022                	sd	s0,0(sp)
    8000510c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000510e:	479d                	li	a5,7
    80005110:	06a7c863          	blt	a5,a0,80005180 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005114:	00016717          	auipc	a4,0x16
    80005118:	eec70713          	addi	a4,a4,-276 # 8001b000 <disk>
    8000511c:	972a                	add	a4,a4,a0
    8000511e:	6789                	lui	a5,0x2
    80005120:	97ba                	add	a5,a5,a4
    80005122:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005126:	e7ad                	bnez	a5,80005190 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005128:	00451793          	slli	a5,a0,0x4
    8000512c:	00018717          	auipc	a4,0x18
    80005130:	ed470713          	addi	a4,a4,-300 # 8001d000 <disk+0x2000>
    80005134:	6314                	ld	a3,0(a4)
    80005136:	96be                	add	a3,a3,a5
    80005138:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000513c:	6314                	ld	a3,0(a4)
    8000513e:	96be                	add	a3,a3,a5
    80005140:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005144:	6314                	ld	a3,0(a4)
    80005146:	96be                	add	a3,a3,a5
    80005148:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000514c:	6318                	ld	a4,0(a4)
    8000514e:	97ba                	add	a5,a5,a4
    80005150:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005154:	00016717          	auipc	a4,0x16
    80005158:	eac70713          	addi	a4,a4,-340 # 8001b000 <disk>
    8000515c:	972a                	add	a4,a4,a0
    8000515e:	6789                	lui	a5,0x2
    80005160:	97ba                	add	a5,a5,a4
    80005162:	4705                	li	a4,1
    80005164:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005168:	00018517          	auipc	a0,0x18
    8000516c:	eb050513          	addi	a0,a0,-336 # 8001d018 <disk+0x2018>
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	52c080e7          	jalr	1324(ra) # 8000169c <wakeup>
}
    80005178:	60a2                	ld	ra,8(sp)
    8000517a:	6402                	ld	s0,0(sp)
    8000517c:	0141                	addi	sp,sp,16
    8000517e:	8082                	ret
    panic("free_desc 1");
    80005180:	00003517          	auipc	a0,0x3
    80005184:	63050513          	addi	a0,a0,1584 # 800087b0 <syscalls+0x320>
    80005188:	00001097          	auipc	ra,0x1
    8000518c:	9c8080e7          	jalr	-1592(ra) # 80005b50 <panic>
    panic("free_desc 2");
    80005190:	00003517          	auipc	a0,0x3
    80005194:	63050513          	addi	a0,a0,1584 # 800087c0 <syscalls+0x330>
    80005198:	00001097          	auipc	ra,0x1
    8000519c:	9b8080e7          	jalr	-1608(ra) # 80005b50 <panic>

00000000800051a0 <virtio_disk_init>:
{
    800051a0:	1101                	addi	sp,sp,-32
    800051a2:	ec06                	sd	ra,24(sp)
    800051a4:	e822                	sd	s0,16(sp)
    800051a6:	e426                	sd	s1,8(sp)
    800051a8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051aa:	00003597          	auipc	a1,0x3
    800051ae:	62658593          	addi	a1,a1,1574 # 800087d0 <syscalls+0x340>
    800051b2:	00018517          	auipc	a0,0x18
    800051b6:	f7650513          	addi	a0,a0,-138 # 8001d128 <disk+0x2128>
    800051ba:	00001097          	auipc	ra,0x1
    800051be:	e3e080e7          	jalr	-450(ra) # 80005ff8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c2:	100017b7          	lui	a5,0x10001
    800051c6:	4398                	lw	a4,0(a5)
    800051c8:	2701                	sext.w	a4,a4
    800051ca:	747277b7          	lui	a5,0x74727
    800051ce:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051d2:	0ef71063          	bne	a4,a5,800052b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800051d6:	100017b7          	lui	a5,0x10001
    800051da:	43dc                	lw	a5,4(a5)
    800051dc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051de:	4705                	li	a4,1
    800051e0:	0ce79963          	bne	a5,a4,800052b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e4:	100017b7          	lui	a5,0x10001
    800051e8:	479c                	lw	a5,8(a5)
    800051ea:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800051ec:	4709                	li	a4,2
    800051ee:	0ce79263          	bne	a5,a4,800052b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051f2:	100017b7          	lui	a5,0x10001
    800051f6:	47d8                	lw	a4,12(a5)
    800051f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051fa:	554d47b7          	lui	a5,0x554d4
    800051fe:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005202:	0af71863          	bne	a4,a5,800052b2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005206:	100017b7          	lui	a5,0x10001
    8000520a:	4705                	li	a4,1
    8000520c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	470d                	li	a4,3
    80005210:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005212:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005214:	c7ffe6b7          	lui	a3,0xc7ffe
    80005218:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000521c:	8f75                	and	a4,a4,a3
    8000521e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005220:	472d                	li	a4,11
    80005222:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005224:	473d                	li	a4,15
    80005226:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005228:	6705                	lui	a4,0x1
    8000522a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000522c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005230:	5bdc                	lw	a5,52(a5)
    80005232:	2781                	sext.w	a5,a5
  if(max == 0)
    80005234:	c7d9                	beqz	a5,800052c2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005236:	471d                	li	a4,7
    80005238:	08f77d63          	bgeu	a4,a5,800052d2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000523c:	100014b7          	lui	s1,0x10001
    80005240:	47a1                	li	a5,8
    80005242:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005244:	6609                	lui	a2,0x2
    80005246:	4581                	li	a1,0
    80005248:	00016517          	auipc	a0,0x16
    8000524c:	db850513          	addi	a0,a0,-584 # 8001b000 <disk>
    80005250:	ffffb097          	auipc	ra,0xffffb
    80005254:	f2a080e7          	jalr	-214(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005258:	00016717          	auipc	a4,0x16
    8000525c:	da870713          	addi	a4,a4,-600 # 8001b000 <disk>
    80005260:	00c75793          	srli	a5,a4,0xc
    80005264:	2781                	sext.w	a5,a5
    80005266:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005268:	00018797          	auipc	a5,0x18
    8000526c:	d9878793          	addi	a5,a5,-616 # 8001d000 <disk+0x2000>
    80005270:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005272:	00016717          	auipc	a4,0x16
    80005276:	e0e70713          	addi	a4,a4,-498 # 8001b080 <disk+0x80>
    8000527a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000527c:	00017717          	auipc	a4,0x17
    80005280:	d8470713          	addi	a4,a4,-636 # 8001c000 <disk+0x1000>
    80005284:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005286:	4705                	li	a4,1
    80005288:	00e78c23          	sb	a4,24(a5)
    8000528c:	00e78ca3          	sb	a4,25(a5)
    80005290:	00e78d23          	sb	a4,26(a5)
    80005294:	00e78da3          	sb	a4,27(a5)
    80005298:	00e78e23          	sb	a4,28(a5)
    8000529c:	00e78ea3          	sb	a4,29(a5)
    800052a0:	00e78f23          	sb	a4,30(a5)
    800052a4:	00e78fa3          	sb	a4,31(a5)
}
    800052a8:	60e2                	ld	ra,24(sp)
    800052aa:	6442                	ld	s0,16(sp)
    800052ac:	64a2                	ld	s1,8(sp)
    800052ae:	6105                	addi	sp,sp,32
    800052b0:	8082                	ret
    panic("could not find virtio disk");
    800052b2:	00003517          	auipc	a0,0x3
    800052b6:	52e50513          	addi	a0,a0,1326 # 800087e0 <syscalls+0x350>
    800052ba:	00001097          	auipc	ra,0x1
    800052be:	896080e7          	jalr	-1898(ra) # 80005b50 <panic>
    panic("virtio disk has no queue 0");
    800052c2:	00003517          	auipc	a0,0x3
    800052c6:	53e50513          	addi	a0,a0,1342 # 80008800 <syscalls+0x370>
    800052ca:	00001097          	auipc	ra,0x1
    800052ce:	886080e7          	jalr	-1914(ra) # 80005b50 <panic>
    panic("virtio disk max queue too short");
    800052d2:	00003517          	auipc	a0,0x3
    800052d6:	54e50513          	addi	a0,a0,1358 # 80008820 <syscalls+0x390>
    800052da:	00001097          	auipc	ra,0x1
    800052de:	876080e7          	jalr	-1930(ra) # 80005b50 <panic>

00000000800052e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800052e2:	7119                	addi	sp,sp,-128
    800052e4:	fc86                	sd	ra,120(sp)
    800052e6:	f8a2                	sd	s0,112(sp)
    800052e8:	f4a6                	sd	s1,104(sp)
    800052ea:	f0ca                	sd	s2,96(sp)
    800052ec:	ecce                	sd	s3,88(sp)
    800052ee:	e8d2                	sd	s4,80(sp)
    800052f0:	e4d6                	sd	s5,72(sp)
    800052f2:	e0da                	sd	s6,64(sp)
    800052f4:	fc5e                	sd	s7,56(sp)
    800052f6:	f862                	sd	s8,48(sp)
    800052f8:	f466                	sd	s9,40(sp)
    800052fa:	f06a                	sd	s10,32(sp)
    800052fc:	ec6e                	sd	s11,24(sp)
    800052fe:	0100                	addi	s0,sp,128
    80005300:	8aaa                	mv	s5,a0
    80005302:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005304:	00c52c83          	lw	s9,12(a0)
    80005308:	001c9c9b          	slliw	s9,s9,0x1
    8000530c:	1c82                	slli	s9,s9,0x20
    8000530e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005312:	00018517          	auipc	a0,0x18
    80005316:	e1650513          	addi	a0,a0,-490 # 8001d128 <disk+0x2128>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	d6e080e7          	jalr	-658(ra) # 80006088 <acquire>
  for(int i = 0; i < 3; i++){
    80005322:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005324:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005326:	00016c17          	auipc	s8,0x16
    8000532a:	cdac0c13          	addi	s8,s8,-806 # 8001b000 <disk>
    8000532e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005330:	4b0d                	li	s6,3
    80005332:	a0ad                	j	8000539c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005334:	00fc0733          	add	a4,s8,a5
    80005338:	975e                	add	a4,a4,s7
    8000533a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000533e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005340:	0207c563          	bltz	a5,8000536a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005344:	2905                	addiw	s2,s2,1
    80005346:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005348:	19690c63          	beq	s2,s6,800054e0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000534c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000534e:	00018717          	auipc	a4,0x18
    80005352:	cca70713          	addi	a4,a4,-822 # 8001d018 <disk+0x2018>
    80005356:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005358:	00074683          	lbu	a3,0(a4)
    8000535c:	fee1                	bnez	a3,80005334 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000535e:	2785                	addiw	a5,a5,1
    80005360:	0705                	addi	a4,a4,1
    80005362:	fe979be3          	bne	a5,s1,80005358 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005366:	57fd                	li	a5,-1
    80005368:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000536a:	01205d63          	blez	s2,80005384 <virtio_disk_rw+0xa2>
    8000536e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005370:	000a2503          	lw	a0,0(s4)
    80005374:	00000097          	auipc	ra,0x0
    80005378:	d92080e7          	jalr	-622(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    8000537c:	2d85                	addiw	s11,s11,1
    8000537e:	0a11                	addi	s4,s4,4
    80005380:	ff2d98e3          	bne	s11,s2,80005370 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005384:	00018597          	auipc	a1,0x18
    80005388:	da458593          	addi	a1,a1,-604 # 8001d128 <disk+0x2128>
    8000538c:	00018517          	auipc	a0,0x18
    80005390:	c8c50513          	addi	a0,a0,-884 # 8001d018 <disk+0x2018>
    80005394:	ffffc097          	auipc	ra,0xffffc
    80005398:	17c080e7          	jalr	380(ra) # 80001510 <sleep>
  for(int i = 0; i < 3; i++){
    8000539c:	f8040a13          	addi	s4,s0,-128
{
    800053a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800053a2:	894e                	mv	s2,s3
    800053a4:	b765                	j	8000534c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800053a6:	00018697          	auipc	a3,0x18
    800053aa:	c5a6b683          	ld	a3,-934(a3) # 8001d000 <disk+0x2000>
    800053ae:	96ba                	add	a3,a3,a4
    800053b0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800053b4:	00016817          	auipc	a6,0x16
    800053b8:	c4c80813          	addi	a6,a6,-948 # 8001b000 <disk>
    800053bc:	00018697          	auipc	a3,0x18
    800053c0:	c4468693          	addi	a3,a3,-956 # 8001d000 <disk+0x2000>
    800053c4:	6290                	ld	a2,0(a3)
    800053c6:	963a                	add	a2,a2,a4
    800053c8:	00c65583          	lhu	a1,12(a2)
    800053cc:	0015e593          	ori	a1,a1,1
    800053d0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800053d4:	f8842603          	lw	a2,-120(s0)
    800053d8:	628c                	ld	a1,0(a3)
    800053da:	972e                	add	a4,a4,a1
    800053dc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800053e0:	20050593          	addi	a1,a0,512
    800053e4:	0592                	slli	a1,a1,0x4
    800053e6:	95c2                	add	a1,a1,a6
    800053e8:	577d                	li	a4,-1
    800053ea:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800053ee:	00461713          	slli	a4,a2,0x4
    800053f2:	6290                	ld	a2,0(a3)
    800053f4:	963a                	add	a2,a2,a4
    800053f6:	03078793          	addi	a5,a5,48
    800053fa:	97c2                	add	a5,a5,a6
    800053fc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800053fe:	629c                	ld	a5,0(a3)
    80005400:	97ba                	add	a5,a5,a4
    80005402:	4605                	li	a2,1
    80005404:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005406:	629c                	ld	a5,0(a3)
    80005408:	97ba                	add	a5,a5,a4
    8000540a:	4809                	li	a6,2
    8000540c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005410:	629c                	ld	a5,0(a3)
    80005412:	97ba                	add	a5,a5,a4
    80005414:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005418:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000541c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005420:	6698                	ld	a4,8(a3)
    80005422:	00275783          	lhu	a5,2(a4)
    80005426:	8b9d                	andi	a5,a5,7
    80005428:	0786                	slli	a5,a5,0x1
    8000542a:	973e                	add	a4,a4,a5
    8000542c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005430:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005434:	6698                	ld	a4,8(a3)
    80005436:	00275783          	lhu	a5,2(a4)
    8000543a:	2785                	addiw	a5,a5,1
    8000543c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005440:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000544c:	004aa783          	lw	a5,4(s5)
    80005450:	02c79163          	bne	a5,a2,80005472 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005454:	00018917          	auipc	s2,0x18
    80005458:	cd490913          	addi	s2,s2,-812 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000545c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000545e:	85ca                	mv	a1,s2
    80005460:	8556                	mv	a0,s5
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	0ae080e7          	jalr	174(ra) # 80001510 <sleep>
  while(b->disk == 1) {
    8000546a:	004aa783          	lw	a5,4(s5)
    8000546e:	fe9788e3          	beq	a5,s1,8000545e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005472:	f8042903          	lw	s2,-128(s0)
    80005476:	20090713          	addi	a4,s2,512
    8000547a:	0712                	slli	a4,a4,0x4
    8000547c:	00016797          	auipc	a5,0x16
    80005480:	b8478793          	addi	a5,a5,-1148 # 8001b000 <disk>
    80005484:	97ba                	add	a5,a5,a4
    80005486:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000548a:	00018997          	auipc	s3,0x18
    8000548e:	b7698993          	addi	s3,s3,-1162 # 8001d000 <disk+0x2000>
    80005492:	00491713          	slli	a4,s2,0x4
    80005496:	0009b783          	ld	a5,0(s3)
    8000549a:	97ba                	add	a5,a5,a4
    8000549c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800054a0:	854a                	mv	a0,s2
    800054a2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800054a6:	00000097          	auipc	ra,0x0
    800054aa:	c60080e7          	jalr	-928(ra) # 80005106 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800054ae:	8885                	andi	s1,s1,1
    800054b0:	f0ed                	bnez	s1,80005492 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800054b2:	00018517          	auipc	a0,0x18
    800054b6:	c7650513          	addi	a0,a0,-906 # 8001d128 <disk+0x2128>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	c82080e7          	jalr	-894(ra) # 8000613c <release>
}
    800054c2:	70e6                	ld	ra,120(sp)
    800054c4:	7446                	ld	s0,112(sp)
    800054c6:	74a6                	ld	s1,104(sp)
    800054c8:	7906                	ld	s2,96(sp)
    800054ca:	69e6                	ld	s3,88(sp)
    800054cc:	6a46                	ld	s4,80(sp)
    800054ce:	6aa6                	ld	s5,72(sp)
    800054d0:	6b06                	ld	s6,64(sp)
    800054d2:	7be2                	ld	s7,56(sp)
    800054d4:	7c42                	ld	s8,48(sp)
    800054d6:	7ca2                	ld	s9,40(sp)
    800054d8:	7d02                	ld	s10,32(sp)
    800054da:	6de2                	ld	s11,24(sp)
    800054dc:	6109                	addi	sp,sp,128
    800054de:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054e0:	f8042503          	lw	a0,-128(s0)
    800054e4:	20050793          	addi	a5,a0,512
    800054e8:	0792                	slli	a5,a5,0x4
  if(write)
    800054ea:	00016817          	auipc	a6,0x16
    800054ee:	b1680813          	addi	a6,a6,-1258 # 8001b000 <disk>
    800054f2:	00f80733          	add	a4,a6,a5
    800054f6:	01a036b3          	snez	a3,s10
    800054fa:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800054fe:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005502:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005506:	7679                	lui	a2,0xffffe
    80005508:	963e                	add	a2,a2,a5
    8000550a:	00018697          	auipc	a3,0x18
    8000550e:	af668693          	addi	a3,a3,-1290 # 8001d000 <disk+0x2000>
    80005512:	6298                	ld	a4,0(a3)
    80005514:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005516:	0a878593          	addi	a1,a5,168
    8000551a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000551c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000551e:	6298                	ld	a4,0(a3)
    80005520:	9732                	add	a4,a4,a2
    80005522:	45c1                	li	a1,16
    80005524:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005526:	6298                	ld	a4,0(a3)
    80005528:	9732                	add	a4,a4,a2
    8000552a:	4585                	li	a1,1
    8000552c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005530:	f8442703          	lw	a4,-124(s0)
    80005534:	628c                	ld	a1,0(a3)
    80005536:	962e                	add	a2,a2,a1
    80005538:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000553c:	0712                	slli	a4,a4,0x4
    8000553e:	6290                	ld	a2,0(a3)
    80005540:	963a                	add	a2,a2,a4
    80005542:	058a8593          	addi	a1,s5,88
    80005546:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005548:	6294                	ld	a3,0(a3)
    8000554a:	96ba                	add	a3,a3,a4
    8000554c:	40000613          	li	a2,1024
    80005550:	c690                	sw	a2,8(a3)
  if(write)
    80005552:	e40d1ae3          	bnez	s10,800053a6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005556:	00018697          	auipc	a3,0x18
    8000555a:	aaa6b683          	ld	a3,-1366(a3) # 8001d000 <disk+0x2000>
    8000555e:	96ba                	add	a3,a3,a4
    80005560:	4609                	li	a2,2
    80005562:	00c69623          	sh	a2,12(a3)
    80005566:	b5b9                	j	800053b4 <virtio_disk_rw+0xd2>

0000000080005568 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005568:	1101                	addi	sp,sp,-32
    8000556a:	ec06                	sd	ra,24(sp)
    8000556c:	e822                	sd	s0,16(sp)
    8000556e:	e426                	sd	s1,8(sp)
    80005570:	e04a                	sd	s2,0(sp)
    80005572:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005574:	00018517          	auipc	a0,0x18
    80005578:	bb450513          	addi	a0,a0,-1100 # 8001d128 <disk+0x2128>
    8000557c:	00001097          	auipc	ra,0x1
    80005580:	b0c080e7          	jalr	-1268(ra) # 80006088 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005584:	10001737          	lui	a4,0x10001
    80005588:	533c                	lw	a5,96(a4)
    8000558a:	8b8d                	andi	a5,a5,3
    8000558c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000558e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005592:	00018797          	auipc	a5,0x18
    80005596:	a6e78793          	addi	a5,a5,-1426 # 8001d000 <disk+0x2000>
    8000559a:	6b94                	ld	a3,16(a5)
    8000559c:	0207d703          	lhu	a4,32(a5)
    800055a0:	0026d783          	lhu	a5,2(a3)
    800055a4:	06f70163          	beq	a4,a5,80005606 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055a8:	00016917          	auipc	s2,0x16
    800055ac:	a5890913          	addi	s2,s2,-1448 # 8001b000 <disk>
    800055b0:	00018497          	auipc	s1,0x18
    800055b4:	a5048493          	addi	s1,s1,-1456 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800055b8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055bc:	6898                	ld	a4,16(s1)
    800055be:	0204d783          	lhu	a5,32(s1)
    800055c2:	8b9d                	andi	a5,a5,7
    800055c4:	078e                	slli	a5,a5,0x3
    800055c6:	97ba                	add	a5,a5,a4
    800055c8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055ca:	20078713          	addi	a4,a5,512
    800055ce:	0712                	slli	a4,a4,0x4
    800055d0:	974a                	add	a4,a4,s2
    800055d2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800055d6:	e731                	bnez	a4,80005622 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055d8:	20078793          	addi	a5,a5,512
    800055dc:	0792                	slli	a5,a5,0x4
    800055de:	97ca                	add	a5,a5,s2
    800055e0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800055e2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055e6:	ffffc097          	auipc	ra,0xffffc
    800055ea:	0b6080e7          	jalr	182(ra) # 8000169c <wakeup>

    disk.used_idx += 1;
    800055ee:	0204d783          	lhu	a5,32(s1)
    800055f2:	2785                	addiw	a5,a5,1
    800055f4:	17c2                	slli	a5,a5,0x30
    800055f6:	93c1                	srli	a5,a5,0x30
    800055f8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055fc:	6898                	ld	a4,16(s1)
    800055fe:	00275703          	lhu	a4,2(a4)
    80005602:	faf71be3          	bne	a4,a5,800055b8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005606:	00018517          	auipc	a0,0x18
    8000560a:	b2250513          	addi	a0,a0,-1246 # 8001d128 <disk+0x2128>
    8000560e:	00001097          	auipc	ra,0x1
    80005612:	b2e080e7          	jalr	-1234(ra) # 8000613c <release>
}
    80005616:	60e2                	ld	ra,24(sp)
    80005618:	6442                	ld	s0,16(sp)
    8000561a:	64a2                	ld	s1,8(sp)
    8000561c:	6902                	ld	s2,0(sp)
    8000561e:	6105                	addi	sp,sp,32
    80005620:	8082                	ret
      panic("virtio_disk_intr status");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	21e50513          	addi	a0,a0,542 # 80008840 <syscalls+0x3b0>
    8000562a:	00000097          	auipc	ra,0x0
    8000562e:	526080e7          	jalr	1318(ra) # 80005b50 <panic>

0000000080005632 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005632:	1141                	addi	sp,sp,-16
    80005634:	e422                	sd	s0,8(sp)
    80005636:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005638:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000563c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005640:	0037979b          	slliw	a5,a5,0x3
    80005644:	02004737          	lui	a4,0x2004
    80005648:	97ba                	add	a5,a5,a4
    8000564a:	0200c737          	lui	a4,0x200c
    8000564e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005652:	000f4637          	lui	a2,0xf4
    80005656:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000565a:	9732                	add	a4,a4,a2
    8000565c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000565e:	00259693          	slli	a3,a1,0x2
    80005662:	96ae                	add	a3,a3,a1
    80005664:	068e                	slli	a3,a3,0x3
    80005666:	00019717          	auipc	a4,0x19
    8000566a:	99a70713          	addi	a4,a4,-1638 # 8001e000 <timer_scratch>
    8000566e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005670:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005672:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005674:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005678:	00000797          	auipc	a5,0x0
    8000567c:	9c878793          	addi	a5,a5,-1592 # 80005040 <timervec>
    80005680:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005684:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005688:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000568c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005690:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005694:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005698:	30479073          	csrw	mie,a5
}
    8000569c:	6422                	ld	s0,8(sp)
    8000569e:	0141                	addi	sp,sp,16
    800056a0:	8082                	ret

00000000800056a2 <start>:
{
    800056a2:	1141                	addi	sp,sp,-16
    800056a4:	e406                	sd	ra,8(sp)
    800056a6:	e022                	sd	s0,0(sp)
    800056a8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056aa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056ae:	7779                	lui	a4,0xffffe
    800056b0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800056b4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056b6:	6705                	lui	a4,0x1
    800056b8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056bc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056be:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056c2:	ffffb797          	auipc	a5,0xffffb
    800056c6:	c5e78793          	addi	a5,a5,-930 # 80000320 <main>
    800056ca:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056ce:	4781                	li	a5,0
    800056d0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800056d4:	67c1                	lui	a5,0x10
    800056d6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800056d8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056dc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056e0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800056e4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800056e8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056ec:	57fd                	li	a5,-1
    800056ee:	83a9                	srli	a5,a5,0xa
    800056f0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056f4:	47bd                	li	a5,15
    800056f6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056fa:	00000097          	auipc	ra,0x0
    800056fe:	f38080e7          	jalr	-200(ra) # 80005632 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005702:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005706:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005708:	823e                	mv	tp,a5
  asm volatile("mret");
    8000570a:	30200073          	mret
}
    8000570e:	60a2                	ld	ra,8(sp)
    80005710:	6402                	ld	s0,0(sp)
    80005712:	0141                	addi	sp,sp,16
    80005714:	8082                	ret

0000000080005716 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005716:	715d                	addi	sp,sp,-80
    80005718:	e486                	sd	ra,72(sp)
    8000571a:	e0a2                	sd	s0,64(sp)
    8000571c:	fc26                	sd	s1,56(sp)
    8000571e:	f84a                	sd	s2,48(sp)
    80005720:	f44e                	sd	s3,40(sp)
    80005722:	f052                	sd	s4,32(sp)
    80005724:	ec56                	sd	s5,24(sp)
    80005726:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005728:	04c05763          	blez	a2,80005776 <consolewrite+0x60>
    8000572c:	8a2a                	mv	s4,a0
    8000572e:	84ae                	mv	s1,a1
    80005730:	89b2                	mv	s3,a2
    80005732:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005734:	5afd                	li	s5,-1
    80005736:	4685                	li	a3,1
    80005738:	8626                	mv	a2,s1
    8000573a:	85d2                	mv	a1,s4
    8000573c:	fbf40513          	addi	a0,s0,-65
    80005740:	ffffc097          	auipc	ra,0xffffc
    80005744:	1ca080e7          	jalr	458(ra) # 8000190a <either_copyin>
    80005748:	01550d63          	beq	a0,s5,80005762 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000574c:	fbf44503          	lbu	a0,-65(s0)
    80005750:	00000097          	auipc	ra,0x0
    80005754:	77e080e7          	jalr	1918(ra) # 80005ece <uartputc>
  for(i = 0; i < n; i++){
    80005758:	2905                	addiw	s2,s2,1
    8000575a:	0485                	addi	s1,s1,1
    8000575c:	fd299de3          	bne	s3,s2,80005736 <consolewrite+0x20>
    80005760:	894e                	mv	s2,s3
  }

  return i;
}
    80005762:	854a                	mv	a0,s2
    80005764:	60a6                	ld	ra,72(sp)
    80005766:	6406                	ld	s0,64(sp)
    80005768:	74e2                	ld	s1,56(sp)
    8000576a:	7942                	ld	s2,48(sp)
    8000576c:	79a2                	ld	s3,40(sp)
    8000576e:	7a02                	ld	s4,32(sp)
    80005770:	6ae2                	ld	s5,24(sp)
    80005772:	6161                	addi	sp,sp,80
    80005774:	8082                	ret
  for(i = 0; i < n; i++){
    80005776:	4901                	li	s2,0
    80005778:	b7ed                	j	80005762 <consolewrite+0x4c>

000000008000577a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000577a:	7159                	addi	sp,sp,-112
    8000577c:	f486                	sd	ra,104(sp)
    8000577e:	f0a2                	sd	s0,96(sp)
    80005780:	eca6                	sd	s1,88(sp)
    80005782:	e8ca                	sd	s2,80(sp)
    80005784:	e4ce                	sd	s3,72(sp)
    80005786:	e0d2                	sd	s4,64(sp)
    80005788:	fc56                	sd	s5,56(sp)
    8000578a:	f85a                	sd	s6,48(sp)
    8000578c:	f45e                	sd	s7,40(sp)
    8000578e:	f062                	sd	s8,32(sp)
    80005790:	ec66                	sd	s9,24(sp)
    80005792:	e86a                	sd	s10,16(sp)
    80005794:	1880                	addi	s0,sp,112
    80005796:	8aaa                	mv	s5,a0
    80005798:	8a2e                	mv	s4,a1
    8000579a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000579c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057a0:	00021517          	auipc	a0,0x21
    800057a4:	9a050513          	addi	a0,a0,-1632 # 80026140 <cons>
    800057a8:	00001097          	auipc	ra,0x1
    800057ac:	8e0080e7          	jalr	-1824(ra) # 80006088 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057b0:	00021497          	auipc	s1,0x21
    800057b4:	99048493          	addi	s1,s1,-1648 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057b8:	00021917          	auipc	s2,0x21
    800057bc:	a2090913          	addi	s2,s2,-1504 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800057c0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057c2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800057c4:	4ca9                	li	s9,10
  while(n > 0){
    800057c6:	07305863          	blez	s3,80005836 <consoleread+0xbc>
    while(cons.r == cons.w){
    800057ca:	0984a783          	lw	a5,152(s1)
    800057ce:	09c4a703          	lw	a4,156(s1)
    800057d2:	02f71463          	bne	a4,a5,800057fa <consoleread+0x80>
      if(myproc()->killed){
    800057d6:	ffffb097          	auipc	ra,0xffffb
    800057da:	66e080e7          	jalr	1646(ra) # 80000e44 <myproc>
    800057de:	551c                	lw	a5,40(a0)
    800057e0:	e7b5                	bnez	a5,8000584c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800057e2:	85a6                	mv	a1,s1
    800057e4:	854a                	mv	a0,s2
    800057e6:	ffffc097          	auipc	ra,0xffffc
    800057ea:	d2a080e7          	jalr	-726(ra) # 80001510 <sleep>
    while(cons.r == cons.w){
    800057ee:	0984a783          	lw	a5,152(s1)
    800057f2:	09c4a703          	lw	a4,156(s1)
    800057f6:	fef700e3          	beq	a4,a5,800057d6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800057fa:	0017871b          	addiw	a4,a5,1
    800057fe:	08e4ac23          	sw	a4,152(s1)
    80005802:	07f7f713          	andi	a4,a5,127
    80005806:	9726                	add	a4,a4,s1
    80005808:	01874703          	lbu	a4,24(a4)
    8000580c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005810:	077d0563          	beq	s10,s7,8000587a <consoleread+0x100>
    cbuf = c;
    80005814:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005818:	4685                	li	a3,1
    8000581a:	f9f40613          	addi	a2,s0,-97
    8000581e:	85d2                	mv	a1,s4
    80005820:	8556                	mv	a0,s5
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	092080e7          	jalr	146(ra) # 800018b4 <either_copyout>
    8000582a:	01850663          	beq	a0,s8,80005836 <consoleread+0xbc>
    dst++;
    8000582e:	0a05                	addi	s4,s4,1
    --n;
    80005830:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005832:	f99d1ae3          	bne	s10,s9,800057c6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005836:	00021517          	auipc	a0,0x21
    8000583a:	90a50513          	addi	a0,a0,-1782 # 80026140 <cons>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	8fe080e7          	jalr	-1794(ra) # 8000613c <release>

  return target - n;
    80005846:	413b053b          	subw	a0,s6,s3
    8000584a:	a811                	j	8000585e <consoleread+0xe4>
        release(&cons.lock);
    8000584c:	00021517          	auipc	a0,0x21
    80005850:	8f450513          	addi	a0,a0,-1804 # 80026140 <cons>
    80005854:	00001097          	auipc	ra,0x1
    80005858:	8e8080e7          	jalr	-1816(ra) # 8000613c <release>
        return -1;
    8000585c:	557d                	li	a0,-1
}
    8000585e:	70a6                	ld	ra,104(sp)
    80005860:	7406                	ld	s0,96(sp)
    80005862:	64e6                	ld	s1,88(sp)
    80005864:	6946                	ld	s2,80(sp)
    80005866:	69a6                	ld	s3,72(sp)
    80005868:	6a06                	ld	s4,64(sp)
    8000586a:	7ae2                	ld	s5,56(sp)
    8000586c:	7b42                	ld	s6,48(sp)
    8000586e:	7ba2                	ld	s7,40(sp)
    80005870:	7c02                	ld	s8,32(sp)
    80005872:	6ce2                	ld	s9,24(sp)
    80005874:	6d42                	ld	s10,16(sp)
    80005876:	6165                	addi	sp,sp,112
    80005878:	8082                	ret
      if(n < target){
    8000587a:	0009871b          	sext.w	a4,s3
    8000587e:	fb677ce3          	bgeu	a4,s6,80005836 <consoleread+0xbc>
        cons.r--;
    80005882:	00021717          	auipc	a4,0x21
    80005886:	94f72b23          	sw	a5,-1706(a4) # 800261d8 <cons+0x98>
    8000588a:	b775                	j	80005836 <consoleread+0xbc>

000000008000588c <consputc>:
{
    8000588c:	1141                	addi	sp,sp,-16
    8000588e:	e406                	sd	ra,8(sp)
    80005890:	e022                	sd	s0,0(sp)
    80005892:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005894:	10000793          	li	a5,256
    80005898:	00f50a63          	beq	a0,a5,800058ac <consputc+0x20>
    uartputc_sync(c);
    8000589c:	00000097          	auipc	ra,0x0
    800058a0:	560080e7          	jalr	1376(ra) # 80005dfc <uartputc_sync>
}
    800058a4:	60a2                	ld	ra,8(sp)
    800058a6:	6402                	ld	s0,0(sp)
    800058a8:	0141                	addi	sp,sp,16
    800058aa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058ac:	4521                	li	a0,8
    800058ae:	00000097          	auipc	ra,0x0
    800058b2:	54e080e7          	jalr	1358(ra) # 80005dfc <uartputc_sync>
    800058b6:	02000513          	li	a0,32
    800058ba:	00000097          	auipc	ra,0x0
    800058be:	542080e7          	jalr	1346(ra) # 80005dfc <uartputc_sync>
    800058c2:	4521                	li	a0,8
    800058c4:	00000097          	auipc	ra,0x0
    800058c8:	538080e7          	jalr	1336(ra) # 80005dfc <uartputc_sync>
    800058cc:	bfe1                	j	800058a4 <consputc+0x18>

00000000800058ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058ce:	1101                	addi	sp,sp,-32
    800058d0:	ec06                	sd	ra,24(sp)
    800058d2:	e822                	sd	s0,16(sp)
    800058d4:	e426                	sd	s1,8(sp)
    800058d6:	e04a                	sd	s2,0(sp)
    800058d8:	1000                	addi	s0,sp,32
    800058da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058dc:	00021517          	auipc	a0,0x21
    800058e0:	86450513          	addi	a0,a0,-1948 # 80026140 <cons>
    800058e4:	00000097          	auipc	ra,0x0
    800058e8:	7a4080e7          	jalr	1956(ra) # 80006088 <acquire>

  switch(c){
    800058ec:	47d5                	li	a5,21
    800058ee:	0af48663          	beq	s1,a5,8000599a <consoleintr+0xcc>
    800058f2:	0297ca63          	blt	a5,s1,80005926 <consoleintr+0x58>
    800058f6:	47a1                	li	a5,8
    800058f8:	0ef48763          	beq	s1,a5,800059e6 <consoleintr+0x118>
    800058fc:	47c1                	li	a5,16
    800058fe:	10f49a63          	bne	s1,a5,80005a12 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005902:	ffffc097          	auipc	ra,0xffffc
    80005906:	05e080e7          	jalr	94(ra) # 80001960 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000590a:	00021517          	auipc	a0,0x21
    8000590e:	83650513          	addi	a0,a0,-1994 # 80026140 <cons>
    80005912:	00001097          	auipc	ra,0x1
    80005916:	82a080e7          	jalr	-2006(ra) # 8000613c <release>
}
    8000591a:	60e2                	ld	ra,24(sp)
    8000591c:	6442                	ld	s0,16(sp)
    8000591e:	64a2                	ld	s1,8(sp)
    80005920:	6902                	ld	s2,0(sp)
    80005922:	6105                	addi	sp,sp,32
    80005924:	8082                	ret
  switch(c){
    80005926:	07f00793          	li	a5,127
    8000592a:	0af48e63          	beq	s1,a5,800059e6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000592e:	00021717          	auipc	a4,0x21
    80005932:	81270713          	addi	a4,a4,-2030 # 80026140 <cons>
    80005936:	0a072783          	lw	a5,160(a4)
    8000593a:	09872703          	lw	a4,152(a4)
    8000593e:	9f99                	subw	a5,a5,a4
    80005940:	07f00713          	li	a4,127
    80005944:	fcf763e3          	bltu	a4,a5,8000590a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005948:	47b5                	li	a5,13
    8000594a:	0cf48763          	beq	s1,a5,80005a18 <consoleintr+0x14a>
      consputc(c);
    8000594e:	8526                	mv	a0,s1
    80005950:	00000097          	auipc	ra,0x0
    80005954:	f3c080e7          	jalr	-196(ra) # 8000588c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005958:	00020797          	auipc	a5,0x20
    8000595c:	7e878793          	addi	a5,a5,2024 # 80026140 <cons>
    80005960:	0a07a703          	lw	a4,160(a5)
    80005964:	0017069b          	addiw	a3,a4,1
    80005968:	0006861b          	sext.w	a2,a3
    8000596c:	0ad7a023          	sw	a3,160(a5)
    80005970:	07f77713          	andi	a4,a4,127
    80005974:	97ba                	add	a5,a5,a4
    80005976:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000597a:	47a9                	li	a5,10
    8000597c:	0cf48563          	beq	s1,a5,80005a46 <consoleintr+0x178>
    80005980:	4791                	li	a5,4
    80005982:	0cf48263          	beq	s1,a5,80005a46 <consoleintr+0x178>
    80005986:	00021797          	auipc	a5,0x21
    8000598a:	8527a783          	lw	a5,-1966(a5) # 800261d8 <cons+0x98>
    8000598e:	0807879b          	addiw	a5,a5,128
    80005992:	f6f61ce3          	bne	a2,a5,8000590a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005996:	863e                	mv	a2,a5
    80005998:	a07d                	j	80005a46 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000599a:	00020717          	auipc	a4,0x20
    8000599e:	7a670713          	addi	a4,a4,1958 # 80026140 <cons>
    800059a2:	0a072783          	lw	a5,160(a4)
    800059a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800059aa:	00020497          	auipc	s1,0x20
    800059ae:	79648493          	addi	s1,s1,1942 # 80026140 <cons>
    while(cons.e != cons.w &&
    800059b2:	4929                	li	s2,10
    800059b4:	f4f70be3          	beq	a4,a5,8000590a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800059b8:	37fd                	addiw	a5,a5,-1
    800059ba:	07f7f713          	andi	a4,a5,127
    800059be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059c0:	01874703          	lbu	a4,24(a4)
    800059c4:	f52703e3          	beq	a4,s2,8000590a <consoleintr+0x3c>
      cons.e--;
    800059c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059cc:	10000513          	li	a0,256
    800059d0:	00000097          	auipc	ra,0x0
    800059d4:	ebc080e7          	jalr	-324(ra) # 8000588c <consputc>
    while(cons.e != cons.w &&
    800059d8:	0a04a783          	lw	a5,160(s1)
    800059dc:	09c4a703          	lw	a4,156(s1)
    800059e0:	fcf71ce3          	bne	a4,a5,800059b8 <consoleintr+0xea>
    800059e4:	b71d                	j	8000590a <consoleintr+0x3c>
    if(cons.e != cons.w){
    800059e6:	00020717          	auipc	a4,0x20
    800059ea:	75a70713          	addi	a4,a4,1882 # 80026140 <cons>
    800059ee:	0a072783          	lw	a5,160(a4)
    800059f2:	09c72703          	lw	a4,156(a4)
    800059f6:	f0f70ae3          	beq	a4,a5,8000590a <consoleintr+0x3c>
      cons.e--;
    800059fa:	37fd                	addiw	a5,a5,-1
    800059fc:	00020717          	auipc	a4,0x20
    80005a00:	7ef72223          	sw	a5,2020(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a04:	10000513          	li	a0,256
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	e84080e7          	jalr	-380(ra) # 8000588c <consputc>
    80005a10:	bded                	j	8000590a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a12:	ee048ce3          	beqz	s1,8000590a <consoleintr+0x3c>
    80005a16:	bf21                	j	8000592e <consoleintr+0x60>
      consputc(c);
    80005a18:	4529                	li	a0,10
    80005a1a:	00000097          	auipc	ra,0x0
    80005a1e:	e72080e7          	jalr	-398(ra) # 8000588c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a22:	00020797          	auipc	a5,0x20
    80005a26:	71e78793          	addi	a5,a5,1822 # 80026140 <cons>
    80005a2a:	0a07a703          	lw	a4,160(a5)
    80005a2e:	0017069b          	addiw	a3,a4,1
    80005a32:	0006861b          	sext.w	a2,a3
    80005a36:	0ad7a023          	sw	a3,160(a5)
    80005a3a:	07f77713          	andi	a4,a4,127
    80005a3e:	97ba                	add	a5,a5,a4
    80005a40:	4729                	li	a4,10
    80005a42:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a46:	00020797          	auipc	a5,0x20
    80005a4a:	78c7ab23          	sw	a2,1942(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005a4e:	00020517          	auipc	a0,0x20
    80005a52:	78a50513          	addi	a0,a0,1930 # 800261d8 <cons+0x98>
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	c46080e7          	jalr	-954(ra) # 8000169c <wakeup>
    80005a5e:	b575                	j	8000590a <consoleintr+0x3c>

0000000080005a60 <consoleinit>:

void
consoleinit(void)
{
    80005a60:	1141                	addi	sp,sp,-16
    80005a62:	e406                	sd	ra,8(sp)
    80005a64:	e022                	sd	s0,0(sp)
    80005a66:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a68:	00003597          	auipc	a1,0x3
    80005a6c:	df058593          	addi	a1,a1,-528 # 80008858 <syscalls+0x3c8>
    80005a70:	00020517          	auipc	a0,0x20
    80005a74:	6d050513          	addi	a0,a0,1744 # 80026140 <cons>
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	580080e7          	jalr	1408(ra) # 80005ff8 <initlock>

  uartinit();
    80005a80:	00000097          	auipc	ra,0x0
    80005a84:	32c080e7          	jalr	812(ra) # 80005dac <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a88:	00013797          	auipc	a5,0x13
    80005a8c:	64078793          	addi	a5,a5,1600 # 800190c8 <devsw>
    80005a90:	00000717          	auipc	a4,0x0
    80005a94:	cea70713          	addi	a4,a4,-790 # 8000577a <consoleread>
    80005a98:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a9a:	00000717          	auipc	a4,0x0
    80005a9e:	c7c70713          	addi	a4,a4,-900 # 80005716 <consolewrite>
    80005aa2:	ef98                	sd	a4,24(a5)
}
    80005aa4:	60a2                	ld	ra,8(sp)
    80005aa6:	6402                	ld	s0,0(sp)
    80005aa8:	0141                	addi	sp,sp,16
    80005aaa:	8082                	ret

0000000080005aac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005aac:	7179                	addi	sp,sp,-48
    80005aae:	f406                	sd	ra,40(sp)
    80005ab0:	f022                	sd	s0,32(sp)
    80005ab2:	ec26                	sd	s1,24(sp)
    80005ab4:	e84a                	sd	s2,16(sp)
    80005ab6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ab8:	c219                	beqz	a2,80005abe <printint+0x12>
    80005aba:	08054763          	bltz	a0,80005b48 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005abe:	2501                	sext.w	a0,a0
    80005ac0:	4881                	li	a7,0
    80005ac2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ac6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ac8:	2581                	sext.w	a1,a1
    80005aca:	00003617          	auipc	a2,0x3
    80005ace:	dbe60613          	addi	a2,a2,-578 # 80008888 <digits>
    80005ad2:	883a                	mv	a6,a4
    80005ad4:	2705                	addiw	a4,a4,1
    80005ad6:	02b577bb          	remuw	a5,a0,a1
    80005ada:	1782                	slli	a5,a5,0x20
    80005adc:	9381                	srli	a5,a5,0x20
    80005ade:	97b2                	add	a5,a5,a2
    80005ae0:	0007c783          	lbu	a5,0(a5)
    80005ae4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ae8:	0005079b          	sext.w	a5,a0
    80005aec:	02b5553b          	divuw	a0,a0,a1
    80005af0:	0685                	addi	a3,a3,1
    80005af2:	feb7f0e3          	bgeu	a5,a1,80005ad2 <printint+0x26>

  if(sign)
    80005af6:	00088c63          	beqz	a7,80005b0e <printint+0x62>
    buf[i++] = '-';
    80005afa:	fe070793          	addi	a5,a4,-32
    80005afe:	00878733          	add	a4,a5,s0
    80005b02:	02d00793          	li	a5,45
    80005b06:	fef70823          	sb	a5,-16(a4)
    80005b0a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b0e:	02e05763          	blez	a4,80005b3c <printint+0x90>
    80005b12:	fd040793          	addi	a5,s0,-48
    80005b16:	00e784b3          	add	s1,a5,a4
    80005b1a:	fff78913          	addi	s2,a5,-1
    80005b1e:	993a                	add	s2,s2,a4
    80005b20:	377d                	addiw	a4,a4,-1
    80005b22:	1702                	slli	a4,a4,0x20
    80005b24:	9301                	srli	a4,a4,0x20
    80005b26:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b2a:	fff4c503          	lbu	a0,-1(s1)
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	d5e080e7          	jalr	-674(ra) # 8000588c <consputc>
  while(--i >= 0)
    80005b36:	14fd                	addi	s1,s1,-1
    80005b38:	ff2499e3          	bne	s1,s2,80005b2a <printint+0x7e>
}
    80005b3c:	70a2                	ld	ra,40(sp)
    80005b3e:	7402                	ld	s0,32(sp)
    80005b40:	64e2                	ld	s1,24(sp)
    80005b42:	6942                	ld	s2,16(sp)
    80005b44:	6145                	addi	sp,sp,48
    80005b46:	8082                	ret
    x = -xx;
    80005b48:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b4c:	4885                	li	a7,1
    x = -xx;
    80005b4e:	bf95                	j	80005ac2 <printint+0x16>

0000000080005b50 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b50:	1101                	addi	sp,sp,-32
    80005b52:	ec06                	sd	ra,24(sp)
    80005b54:	e822                	sd	s0,16(sp)
    80005b56:	e426                	sd	s1,8(sp)
    80005b58:	1000                	addi	s0,sp,32
    80005b5a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b5c:	00020797          	auipc	a5,0x20
    80005b60:	6a07a223          	sw	zero,1700(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005b64:	00003517          	auipc	a0,0x3
    80005b68:	cfc50513          	addi	a0,a0,-772 # 80008860 <syscalls+0x3d0>
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	02e080e7          	jalr	46(ra) # 80005b9a <printf>
  printf(s);
    80005b74:	8526                	mv	a0,s1
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	024080e7          	jalr	36(ra) # 80005b9a <printf>
  printf("\n");
    80005b7e:	00002517          	auipc	a0,0x2
    80005b82:	4ca50513          	addi	a0,a0,1226 # 80008048 <etext+0x48>
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	014080e7          	jalr	20(ra) # 80005b9a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b8e:	4785                	li	a5,1
    80005b90:	00003717          	auipc	a4,0x3
    80005b94:	48f72623          	sw	a5,1164(a4) # 8000901c <panicked>
  for(;;)
    80005b98:	a001                	j	80005b98 <panic+0x48>

0000000080005b9a <printf>:
{
    80005b9a:	7131                	addi	sp,sp,-192
    80005b9c:	fc86                	sd	ra,120(sp)
    80005b9e:	f8a2                	sd	s0,112(sp)
    80005ba0:	f4a6                	sd	s1,104(sp)
    80005ba2:	f0ca                	sd	s2,96(sp)
    80005ba4:	ecce                	sd	s3,88(sp)
    80005ba6:	e8d2                	sd	s4,80(sp)
    80005ba8:	e4d6                	sd	s5,72(sp)
    80005baa:	e0da                	sd	s6,64(sp)
    80005bac:	fc5e                	sd	s7,56(sp)
    80005bae:	f862                	sd	s8,48(sp)
    80005bb0:	f466                	sd	s9,40(sp)
    80005bb2:	f06a                	sd	s10,32(sp)
    80005bb4:	ec6e                	sd	s11,24(sp)
    80005bb6:	0100                	addi	s0,sp,128
    80005bb8:	8a2a                	mv	s4,a0
    80005bba:	e40c                	sd	a1,8(s0)
    80005bbc:	e810                	sd	a2,16(s0)
    80005bbe:	ec14                	sd	a3,24(s0)
    80005bc0:	f018                	sd	a4,32(s0)
    80005bc2:	f41c                	sd	a5,40(s0)
    80005bc4:	03043823          	sd	a6,48(s0)
    80005bc8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005bcc:	00020d97          	auipc	s11,0x20
    80005bd0:	634dad83          	lw	s11,1588(s11) # 80026200 <pr+0x18>
  if(locking)
    80005bd4:	020d9b63          	bnez	s11,80005c0a <printf+0x70>
  if (fmt == 0)
    80005bd8:	040a0263          	beqz	s4,80005c1c <printf+0x82>
  va_start(ap, fmt);
    80005bdc:	00840793          	addi	a5,s0,8
    80005be0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005be4:	000a4503          	lbu	a0,0(s4)
    80005be8:	14050f63          	beqz	a0,80005d46 <printf+0x1ac>
    80005bec:	4981                	li	s3,0
    if(c != '%'){
    80005bee:	02500a93          	li	s5,37
    switch(c){
    80005bf2:	07000b93          	li	s7,112
  consputc('x');
    80005bf6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005bf8:	00003b17          	auipc	s6,0x3
    80005bfc:	c90b0b13          	addi	s6,s6,-880 # 80008888 <digits>
    switch(c){
    80005c00:	07300c93          	li	s9,115
    80005c04:	06400c13          	li	s8,100
    80005c08:	a82d                	j	80005c42 <printf+0xa8>
    acquire(&pr.lock);
    80005c0a:	00020517          	auipc	a0,0x20
    80005c0e:	5de50513          	addi	a0,a0,1502 # 800261e8 <pr>
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	476080e7          	jalr	1142(ra) # 80006088 <acquire>
    80005c1a:	bf7d                	j	80005bd8 <printf+0x3e>
    panic("null fmt");
    80005c1c:	00003517          	auipc	a0,0x3
    80005c20:	c5450513          	addi	a0,a0,-940 # 80008870 <syscalls+0x3e0>
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	f2c080e7          	jalr	-212(ra) # 80005b50 <panic>
      consputc(c);
    80005c2c:	00000097          	auipc	ra,0x0
    80005c30:	c60080e7          	jalr	-928(ra) # 8000588c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c34:	2985                	addiw	s3,s3,1
    80005c36:	013a07b3          	add	a5,s4,s3
    80005c3a:	0007c503          	lbu	a0,0(a5)
    80005c3e:	10050463          	beqz	a0,80005d46 <printf+0x1ac>
    if(c != '%'){
    80005c42:	ff5515e3          	bne	a0,s5,80005c2c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c46:	2985                	addiw	s3,s3,1
    80005c48:	013a07b3          	add	a5,s4,s3
    80005c4c:	0007c783          	lbu	a5,0(a5)
    80005c50:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c54:	cbed                	beqz	a5,80005d46 <printf+0x1ac>
    switch(c){
    80005c56:	05778a63          	beq	a5,s7,80005caa <printf+0x110>
    80005c5a:	02fbf663          	bgeu	s7,a5,80005c86 <printf+0xec>
    80005c5e:	09978863          	beq	a5,s9,80005cee <printf+0x154>
    80005c62:	07800713          	li	a4,120
    80005c66:	0ce79563          	bne	a5,a4,80005d30 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005c6a:	f8843783          	ld	a5,-120(s0)
    80005c6e:	00878713          	addi	a4,a5,8
    80005c72:	f8e43423          	sd	a4,-120(s0)
    80005c76:	4605                	li	a2,1
    80005c78:	85ea                	mv	a1,s10
    80005c7a:	4388                	lw	a0,0(a5)
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	e30080e7          	jalr	-464(ra) # 80005aac <printint>
      break;
    80005c84:	bf45                	j	80005c34 <printf+0x9a>
    switch(c){
    80005c86:	09578f63          	beq	a5,s5,80005d24 <printf+0x18a>
    80005c8a:	0b879363          	bne	a5,s8,80005d30 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005c8e:	f8843783          	ld	a5,-120(s0)
    80005c92:	00878713          	addi	a4,a5,8
    80005c96:	f8e43423          	sd	a4,-120(s0)
    80005c9a:	4605                	li	a2,1
    80005c9c:	45a9                	li	a1,10
    80005c9e:	4388                	lw	a0,0(a5)
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	e0c080e7          	jalr	-500(ra) # 80005aac <printint>
      break;
    80005ca8:	b771                	j	80005c34 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005caa:	f8843783          	ld	a5,-120(s0)
    80005cae:	00878713          	addi	a4,a5,8
    80005cb2:	f8e43423          	sd	a4,-120(s0)
    80005cb6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005cba:	03000513          	li	a0,48
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	bce080e7          	jalr	-1074(ra) # 8000588c <consputc>
  consputc('x');
    80005cc6:	07800513          	li	a0,120
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	bc2080e7          	jalr	-1086(ra) # 8000588c <consputc>
    80005cd2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cd4:	03c95793          	srli	a5,s2,0x3c
    80005cd8:	97da                	add	a5,a5,s6
    80005cda:	0007c503          	lbu	a0,0(a5)
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	bae080e7          	jalr	-1106(ra) # 8000588c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ce6:	0912                	slli	s2,s2,0x4
    80005ce8:	34fd                	addiw	s1,s1,-1
    80005cea:	f4ed                	bnez	s1,80005cd4 <printf+0x13a>
    80005cec:	b7a1                	j	80005c34 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005cee:	f8843783          	ld	a5,-120(s0)
    80005cf2:	00878713          	addi	a4,a5,8
    80005cf6:	f8e43423          	sd	a4,-120(s0)
    80005cfa:	6384                	ld	s1,0(a5)
    80005cfc:	cc89                	beqz	s1,80005d16 <printf+0x17c>
      for(; *s; s++)
    80005cfe:	0004c503          	lbu	a0,0(s1)
    80005d02:	d90d                	beqz	a0,80005c34 <printf+0x9a>
        consputc(*s);
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	b88080e7          	jalr	-1144(ra) # 8000588c <consputc>
      for(; *s; s++)
    80005d0c:	0485                	addi	s1,s1,1
    80005d0e:	0004c503          	lbu	a0,0(s1)
    80005d12:	f96d                	bnez	a0,80005d04 <printf+0x16a>
    80005d14:	b705                	j	80005c34 <printf+0x9a>
        s = "(null)";
    80005d16:	00003497          	auipc	s1,0x3
    80005d1a:	b5248493          	addi	s1,s1,-1198 # 80008868 <syscalls+0x3d8>
      for(; *s; s++)
    80005d1e:	02800513          	li	a0,40
    80005d22:	b7cd                	j	80005d04 <printf+0x16a>
      consputc('%');
    80005d24:	8556                	mv	a0,s5
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	b66080e7          	jalr	-1178(ra) # 8000588c <consputc>
      break;
    80005d2e:	b719                	j	80005c34 <printf+0x9a>
      consputc('%');
    80005d30:	8556                	mv	a0,s5
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	b5a080e7          	jalr	-1190(ra) # 8000588c <consputc>
      consputc(c);
    80005d3a:	8526                	mv	a0,s1
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	b50080e7          	jalr	-1200(ra) # 8000588c <consputc>
      break;
    80005d44:	bdc5                	j	80005c34 <printf+0x9a>
  if(locking)
    80005d46:	020d9163          	bnez	s11,80005d68 <printf+0x1ce>
}
    80005d4a:	70e6                	ld	ra,120(sp)
    80005d4c:	7446                	ld	s0,112(sp)
    80005d4e:	74a6                	ld	s1,104(sp)
    80005d50:	7906                	ld	s2,96(sp)
    80005d52:	69e6                	ld	s3,88(sp)
    80005d54:	6a46                	ld	s4,80(sp)
    80005d56:	6aa6                	ld	s5,72(sp)
    80005d58:	6b06                	ld	s6,64(sp)
    80005d5a:	7be2                	ld	s7,56(sp)
    80005d5c:	7c42                	ld	s8,48(sp)
    80005d5e:	7ca2                	ld	s9,40(sp)
    80005d60:	7d02                	ld	s10,32(sp)
    80005d62:	6de2                	ld	s11,24(sp)
    80005d64:	6129                	addi	sp,sp,192
    80005d66:	8082                	ret
    release(&pr.lock);
    80005d68:	00020517          	auipc	a0,0x20
    80005d6c:	48050513          	addi	a0,a0,1152 # 800261e8 <pr>
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	3cc080e7          	jalr	972(ra) # 8000613c <release>
}
    80005d78:	bfc9                	j	80005d4a <printf+0x1b0>

0000000080005d7a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d7a:	1101                	addi	sp,sp,-32
    80005d7c:	ec06                	sd	ra,24(sp)
    80005d7e:	e822                	sd	s0,16(sp)
    80005d80:	e426                	sd	s1,8(sp)
    80005d82:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d84:	00020497          	auipc	s1,0x20
    80005d88:	46448493          	addi	s1,s1,1124 # 800261e8 <pr>
    80005d8c:	00003597          	auipc	a1,0x3
    80005d90:	af458593          	addi	a1,a1,-1292 # 80008880 <syscalls+0x3f0>
    80005d94:	8526                	mv	a0,s1
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	262080e7          	jalr	610(ra) # 80005ff8 <initlock>
  pr.locking = 1;
    80005d9e:	4785                	li	a5,1
    80005da0:	cc9c                	sw	a5,24(s1)
}
    80005da2:	60e2                	ld	ra,24(sp)
    80005da4:	6442                	ld	s0,16(sp)
    80005da6:	64a2                	ld	s1,8(sp)
    80005da8:	6105                	addi	sp,sp,32
    80005daa:	8082                	ret

0000000080005dac <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005dac:	1141                	addi	sp,sp,-16
    80005dae:	e406                	sd	ra,8(sp)
    80005db0:	e022                	sd	s0,0(sp)
    80005db2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005db4:	100007b7          	lui	a5,0x10000
    80005db8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005dbc:	f8000713          	li	a4,-128
    80005dc0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005dc4:	470d                	li	a4,3
    80005dc6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005dca:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005dce:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005dd2:	469d                	li	a3,7
    80005dd4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005dd8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ddc:	00003597          	auipc	a1,0x3
    80005de0:	ac458593          	addi	a1,a1,-1340 # 800088a0 <digits+0x18>
    80005de4:	00020517          	auipc	a0,0x20
    80005de8:	42450513          	addi	a0,a0,1060 # 80026208 <uart_tx_lock>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	20c080e7          	jalr	524(ra) # 80005ff8 <initlock>
}
    80005df4:	60a2                	ld	ra,8(sp)
    80005df6:	6402                	ld	s0,0(sp)
    80005df8:	0141                	addi	sp,sp,16
    80005dfa:	8082                	ret

0000000080005dfc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005dfc:	1101                	addi	sp,sp,-32
    80005dfe:	ec06                	sd	ra,24(sp)
    80005e00:	e822                	sd	s0,16(sp)
    80005e02:	e426                	sd	s1,8(sp)
    80005e04:	1000                	addi	s0,sp,32
    80005e06:	84aa                	mv	s1,a0
  push_off();
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	234080e7          	jalr	564(ra) # 8000603c <push_off>

  if(panicked){
    80005e10:	00003797          	auipc	a5,0x3
    80005e14:	20c7a783          	lw	a5,524(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e18:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e1c:	c391                	beqz	a5,80005e20 <uartputc_sync+0x24>
    for(;;)
    80005e1e:	a001                	j	80005e1e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e20:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e24:	0207f793          	andi	a5,a5,32
    80005e28:	dfe5                	beqz	a5,80005e20 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e2a:	0ff4f513          	zext.b	a0,s1
    80005e2e:	100007b7          	lui	a5,0x10000
    80005e32:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	2a6080e7          	jalr	678(ra) # 800060dc <pop_off>
}
    80005e3e:	60e2                	ld	ra,24(sp)
    80005e40:	6442                	ld	s0,16(sp)
    80005e42:	64a2                	ld	s1,8(sp)
    80005e44:	6105                	addi	sp,sp,32
    80005e46:	8082                	ret

0000000080005e48 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e48:	00003797          	auipc	a5,0x3
    80005e4c:	1d87b783          	ld	a5,472(a5) # 80009020 <uart_tx_r>
    80005e50:	00003717          	auipc	a4,0x3
    80005e54:	1d873703          	ld	a4,472(a4) # 80009028 <uart_tx_w>
    80005e58:	06f70a63          	beq	a4,a5,80005ecc <uartstart+0x84>
{
    80005e5c:	7139                	addi	sp,sp,-64
    80005e5e:	fc06                	sd	ra,56(sp)
    80005e60:	f822                	sd	s0,48(sp)
    80005e62:	f426                	sd	s1,40(sp)
    80005e64:	f04a                	sd	s2,32(sp)
    80005e66:	ec4e                	sd	s3,24(sp)
    80005e68:	e852                	sd	s4,16(sp)
    80005e6a:	e456                	sd	s5,8(sp)
    80005e6c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e6e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e72:	00020a17          	auipc	s4,0x20
    80005e76:	396a0a13          	addi	s4,s4,918 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005e7a:	00003497          	auipc	s1,0x3
    80005e7e:	1a648493          	addi	s1,s1,422 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e82:	00003997          	auipc	s3,0x3
    80005e86:	1a698993          	addi	s3,s3,422 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e8a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e8e:	02077713          	andi	a4,a4,32
    80005e92:	c705                	beqz	a4,80005eba <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e94:	01f7f713          	andi	a4,a5,31
    80005e98:	9752                	add	a4,a4,s4
    80005e9a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005e9e:	0785                	addi	a5,a5,1
    80005ea0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ea2:	8526                	mv	a0,s1
    80005ea4:	ffffb097          	auipc	ra,0xffffb
    80005ea8:	7f8080e7          	jalr	2040(ra) # 8000169c <wakeup>
    
    WriteReg(THR, c);
    80005eac:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005eb0:	609c                	ld	a5,0(s1)
    80005eb2:	0009b703          	ld	a4,0(s3)
    80005eb6:	fcf71ae3          	bne	a4,a5,80005e8a <uartstart+0x42>
  }
}
    80005eba:	70e2                	ld	ra,56(sp)
    80005ebc:	7442                	ld	s0,48(sp)
    80005ebe:	74a2                	ld	s1,40(sp)
    80005ec0:	7902                	ld	s2,32(sp)
    80005ec2:	69e2                	ld	s3,24(sp)
    80005ec4:	6a42                	ld	s4,16(sp)
    80005ec6:	6aa2                	ld	s5,8(sp)
    80005ec8:	6121                	addi	sp,sp,64
    80005eca:	8082                	ret
    80005ecc:	8082                	ret

0000000080005ece <uartputc>:
{
    80005ece:	7179                	addi	sp,sp,-48
    80005ed0:	f406                	sd	ra,40(sp)
    80005ed2:	f022                	sd	s0,32(sp)
    80005ed4:	ec26                	sd	s1,24(sp)
    80005ed6:	e84a                	sd	s2,16(sp)
    80005ed8:	e44e                	sd	s3,8(sp)
    80005eda:	e052                	sd	s4,0(sp)
    80005edc:	1800                	addi	s0,sp,48
    80005ede:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ee0:	00020517          	auipc	a0,0x20
    80005ee4:	32850513          	addi	a0,a0,808 # 80026208 <uart_tx_lock>
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	1a0080e7          	jalr	416(ra) # 80006088 <acquire>
  if(panicked){
    80005ef0:	00003797          	auipc	a5,0x3
    80005ef4:	12c7a783          	lw	a5,300(a5) # 8000901c <panicked>
    80005ef8:	c391                	beqz	a5,80005efc <uartputc+0x2e>
    for(;;)
    80005efa:	a001                	j	80005efa <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005efc:	00003717          	auipc	a4,0x3
    80005f00:	12c73703          	ld	a4,300(a4) # 80009028 <uart_tx_w>
    80005f04:	00003797          	auipc	a5,0x3
    80005f08:	11c7b783          	ld	a5,284(a5) # 80009020 <uart_tx_r>
    80005f0c:	02078793          	addi	a5,a5,32
    80005f10:	02e79b63          	bne	a5,a4,80005f46 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f14:	00020997          	auipc	s3,0x20
    80005f18:	2f498993          	addi	s3,s3,756 # 80026208 <uart_tx_lock>
    80005f1c:	00003497          	auipc	s1,0x3
    80005f20:	10448493          	addi	s1,s1,260 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f24:	00003917          	auipc	s2,0x3
    80005f28:	10490913          	addi	s2,s2,260 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f2c:	85ce                	mv	a1,s3
    80005f2e:	8526                	mv	a0,s1
    80005f30:	ffffb097          	auipc	ra,0xffffb
    80005f34:	5e0080e7          	jalr	1504(ra) # 80001510 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f38:	00093703          	ld	a4,0(s2)
    80005f3c:	609c                	ld	a5,0(s1)
    80005f3e:	02078793          	addi	a5,a5,32
    80005f42:	fee785e3          	beq	a5,a4,80005f2c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f46:	00020497          	auipc	s1,0x20
    80005f4a:	2c248493          	addi	s1,s1,706 # 80026208 <uart_tx_lock>
    80005f4e:	01f77793          	andi	a5,a4,31
    80005f52:	97a6                	add	a5,a5,s1
    80005f54:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80005f58:	0705                	addi	a4,a4,1
    80005f5a:	00003797          	auipc	a5,0x3
    80005f5e:	0ce7b723          	sd	a4,206(a5) # 80009028 <uart_tx_w>
      uartstart();
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	ee6080e7          	jalr	-282(ra) # 80005e48 <uartstart>
      release(&uart_tx_lock);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	1d0080e7          	jalr	464(ra) # 8000613c <release>
}
    80005f74:	70a2                	ld	ra,40(sp)
    80005f76:	7402                	ld	s0,32(sp)
    80005f78:	64e2                	ld	s1,24(sp)
    80005f7a:	6942                	ld	s2,16(sp)
    80005f7c:	69a2                	ld	s3,8(sp)
    80005f7e:	6a02                	ld	s4,0(sp)
    80005f80:	6145                	addi	sp,sp,48
    80005f82:	8082                	ret

0000000080005f84 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f84:	1141                	addi	sp,sp,-16
    80005f86:	e422                	sd	s0,8(sp)
    80005f88:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f8a:	100007b7          	lui	a5,0x10000
    80005f8e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f92:	8b85                	andi	a5,a5,1
    80005f94:	cb81                	beqz	a5,80005fa4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005f96:	100007b7          	lui	a5,0x10000
    80005f9a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005f9e:	6422                	ld	s0,8(sp)
    80005fa0:	0141                	addi	sp,sp,16
    80005fa2:	8082                	ret
    return -1;
    80005fa4:	557d                	li	a0,-1
    80005fa6:	bfe5                	j	80005f9e <uartgetc+0x1a>

0000000080005fa8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005fa8:	1101                	addi	sp,sp,-32
    80005faa:	ec06                	sd	ra,24(sp)
    80005fac:	e822                	sd	s0,16(sp)
    80005fae:	e426                	sd	s1,8(sp)
    80005fb0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005fb2:	54fd                	li	s1,-1
    80005fb4:	a029                	j	80005fbe <uartintr+0x16>
      break;
    consoleintr(c);
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	918080e7          	jalr	-1768(ra) # 800058ce <consoleintr>
    int c = uartgetc();
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	fc6080e7          	jalr	-58(ra) # 80005f84 <uartgetc>
    if(c == -1)
    80005fc6:	fe9518e3          	bne	a0,s1,80005fb6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005fca:	00020497          	auipc	s1,0x20
    80005fce:	23e48493          	addi	s1,s1,574 # 80026208 <uart_tx_lock>
    80005fd2:	8526                	mv	a0,s1
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	0b4080e7          	jalr	180(ra) # 80006088 <acquire>
  uartstart();
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	e6c080e7          	jalr	-404(ra) # 80005e48 <uartstart>
  release(&uart_tx_lock);
    80005fe4:	8526                	mv	a0,s1
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	156080e7          	jalr	342(ra) # 8000613c <release>
}
    80005fee:	60e2                	ld	ra,24(sp)
    80005ff0:	6442                	ld	s0,16(sp)
    80005ff2:	64a2                	ld	s1,8(sp)
    80005ff4:	6105                	addi	sp,sp,32
    80005ff6:	8082                	ret

0000000080005ff8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005ff8:	1141                	addi	sp,sp,-16
    80005ffa:	e422                	sd	s0,8(sp)
    80005ffc:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ffe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006000:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006004:	00053823          	sd	zero,16(a0)
}
    80006008:	6422                	ld	s0,8(sp)
    8000600a:	0141                	addi	sp,sp,16
    8000600c:	8082                	ret

000000008000600e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000600e:	411c                	lw	a5,0(a0)
    80006010:	e399                	bnez	a5,80006016 <holding+0x8>
    80006012:	4501                	li	a0,0
  return r;
}
    80006014:	8082                	ret
{
    80006016:	1101                	addi	sp,sp,-32
    80006018:	ec06                	sd	ra,24(sp)
    8000601a:	e822                	sd	s0,16(sp)
    8000601c:	e426                	sd	s1,8(sp)
    8000601e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006020:	6904                	ld	s1,16(a0)
    80006022:	ffffb097          	auipc	ra,0xffffb
    80006026:	e06080e7          	jalr	-506(ra) # 80000e28 <mycpu>
    8000602a:	40a48533          	sub	a0,s1,a0
    8000602e:	00153513          	seqz	a0,a0
}
    80006032:	60e2                	ld	ra,24(sp)
    80006034:	6442                	ld	s0,16(sp)
    80006036:	64a2                	ld	s1,8(sp)
    80006038:	6105                	addi	sp,sp,32
    8000603a:	8082                	ret

000000008000603c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000603c:	1101                	addi	sp,sp,-32
    8000603e:	ec06                	sd	ra,24(sp)
    80006040:	e822                	sd	s0,16(sp)
    80006042:	e426                	sd	s1,8(sp)
    80006044:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006046:	100024f3          	csrr	s1,sstatus
    8000604a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000604e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006050:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	dd4080e7          	jalr	-556(ra) # 80000e28 <mycpu>
    8000605c:	5d3c                	lw	a5,120(a0)
    8000605e:	cf89                	beqz	a5,80006078 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006060:	ffffb097          	auipc	ra,0xffffb
    80006064:	dc8080e7          	jalr	-568(ra) # 80000e28 <mycpu>
    80006068:	5d3c                	lw	a5,120(a0)
    8000606a:	2785                	addiw	a5,a5,1
    8000606c:	dd3c                	sw	a5,120(a0)
}
    8000606e:	60e2                	ld	ra,24(sp)
    80006070:	6442                	ld	s0,16(sp)
    80006072:	64a2                	ld	s1,8(sp)
    80006074:	6105                	addi	sp,sp,32
    80006076:	8082                	ret
    mycpu()->intena = old;
    80006078:	ffffb097          	auipc	ra,0xffffb
    8000607c:	db0080e7          	jalr	-592(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006080:	8085                	srli	s1,s1,0x1
    80006082:	8885                	andi	s1,s1,1
    80006084:	dd64                	sw	s1,124(a0)
    80006086:	bfe9                	j	80006060 <push_off+0x24>

0000000080006088 <acquire>:
{
    80006088:	1101                	addi	sp,sp,-32
    8000608a:	ec06                	sd	ra,24(sp)
    8000608c:	e822                	sd	s0,16(sp)
    8000608e:	e426                	sd	s1,8(sp)
    80006090:	1000                	addi	s0,sp,32
    80006092:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006094:	00000097          	auipc	ra,0x0
    80006098:	fa8080e7          	jalr	-88(ra) # 8000603c <push_off>
  if(holding(lk))
    8000609c:	8526                	mv	a0,s1
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	f70080e7          	jalr	-144(ra) # 8000600e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060a6:	4705                	li	a4,1
  if(holding(lk))
    800060a8:	e115                	bnez	a0,800060cc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060aa:	87ba                	mv	a5,a4
    800060ac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060b0:	2781                	sext.w	a5,a5
    800060b2:	ffe5                	bnez	a5,800060aa <acquire+0x22>
  __sync_synchronize();
    800060b4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060b8:	ffffb097          	auipc	ra,0xffffb
    800060bc:	d70080e7          	jalr	-656(ra) # 80000e28 <mycpu>
    800060c0:	e888                	sd	a0,16(s1)
}
    800060c2:	60e2                	ld	ra,24(sp)
    800060c4:	6442                	ld	s0,16(sp)
    800060c6:	64a2                	ld	s1,8(sp)
    800060c8:	6105                	addi	sp,sp,32
    800060ca:	8082                	ret
    panic("acquire");
    800060cc:	00002517          	auipc	a0,0x2
    800060d0:	7dc50513          	addi	a0,a0,2012 # 800088a8 <digits+0x20>
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	a7c080e7          	jalr	-1412(ra) # 80005b50 <panic>

00000000800060dc <pop_off>:

void
pop_off(void)
{
    800060dc:	1141                	addi	sp,sp,-16
    800060de:	e406                	sd	ra,8(sp)
    800060e0:	e022                	sd	s0,0(sp)
    800060e2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800060e4:	ffffb097          	auipc	ra,0xffffb
    800060e8:	d44080e7          	jalr	-700(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060ec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800060f0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800060f2:	e78d                	bnez	a5,8000611c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800060f4:	5d3c                	lw	a5,120(a0)
    800060f6:	02f05b63          	blez	a5,8000612c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800060fa:	37fd                	addiw	a5,a5,-1
    800060fc:	0007871b          	sext.w	a4,a5
    80006100:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006102:	eb09                	bnez	a4,80006114 <pop_off+0x38>
    80006104:	5d7c                	lw	a5,124(a0)
    80006106:	c799                	beqz	a5,80006114 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006108:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000610c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006110:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006114:	60a2                	ld	ra,8(sp)
    80006116:	6402                	ld	s0,0(sp)
    80006118:	0141                	addi	sp,sp,16
    8000611a:	8082                	ret
    panic("pop_off - interruptible");
    8000611c:	00002517          	auipc	a0,0x2
    80006120:	79450513          	addi	a0,a0,1940 # 800088b0 <digits+0x28>
    80006124:	00000097          	auipc	ra,0x0
    80006128:	a2c080e7          	jalr	-1492(ra) # 80005b50 <panic>
    panic("pop_off");
    8000612c:	00002517          	auipc	a0,0x2
    80006130:	79c50513          	addi	a0,a0,1948 # 800088c8 <digits+0x40>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	a1c080e7          	jalr	-1508(ra) # 80005b50 <panic>

000000008000613c <release>:
{
    8000613c:	1101                	addi	sp,sp,-32
    8000613e:	ec06                	sd	ra,24(sp)
    80006140:	e822                	sd	s0,16(sp)
    80006142:	e426                	sd	s1,8(sp)
    80006144:	1000                	addi	s0,sp,32
    80006146:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	ec6080e7          	jalr	-314(ra) # 8000600e <holding>
    80006150:	c115                	beqz	a0,80006174 <release+0x38>
  lk->cpu = 0;
    80006152:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006156:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000615a:	0f50000f          	fence	iorw,ow
    8000615e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006162:	00000097          	auipc	ra,0x0
    80006166:	f7a080e7          	jalr	-134(ra) # 800060dc <pop_off>
}
    8000616a:	60e2                	ld	ra,24(sp)
    8000616c:	6442                	ld	s0,16(sp)
    8000616e:	64a2                	ld	s1,8(sp)
    80006170:	6105                	addi	sp,sp,32
    80006172:	8082                	ret
    panic("release");
    80006174:	00002517          	auipc	a0,0x2
    80006178:	75c50513          	addi	a0,a0,1884 # 800088d0 <digits+0x48>
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	9d4080e7          	jalr	-1580(ra) # 80005b50 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
