//
//  HSRuntime_switch_arm64.s
//  HSHUDHelper
//
//  Created by viewat on 16/6/24.
//  Copyright © 2016年 HS. All rights reserved.
//


#if defined(__x86_64__)


	.globl	_hs_switch_block_func
	.align	4, 0x90
_hs_switch_block_func:
    movq    %rbp, __hs_tmp_store(%rip) // save %rbp even though never changed
	movq	%rdi, __hs_tmp_store+8(%rip)
	movq	%rsi, __hs_tmp_store+16(%rip)
	movq	%rdx, __hs_tmp_store+24(%rip)
	movq	%rcx, __hs_tmp_store+32(%rip)
	movq	%r8, __hs_tmp_store+40(%rip)
	movq	%r9, __hs_tmp_store+48(%rip)

    // save %xmm0~%xmm7 for floating-point arguments
    movsd   %xmm0, __hs_tmp_store+200(%rip)
    movsd   %xmm1, __hs_tmp_store+216(%rip)
    movsd   %xmm2, __hs_tmp_store+232(%rip)
    movsd   %xmm3, __hs_tmp_store+248(%rip)
    movsd   %xmm4, __hs_tmp_store+264(%rip)
    movsd   %xmm5, __hs_tmp_store+280(%rip)
    movsd   %xmm6, __hs_tmp_store+296(%rip)
    movsd   %xmm7, __hs_tmp_store+312(%rip)


    // pop return address pointer from stack and save
    popq	%rax
    movq	%rax, __hs_tmp_store+72(%rip)

    // x0(originSelector) = [self hs_selectorForOriginMethod:x1]
    movq    __hs_tmp_store+8(%rip), %rdi
    movq    __hs_tmp_store+16(%rip), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.2(%rip), %rsi

    callq	_objc_msgSend
    movq	%rax, __hs_tmp_store+80(%rip)

    // [self hs_executeBlockBeforeMethod:originSelector]
    movq	__hs_tmp_store+80(%rip), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.4(%rip), %rsi
    movq	__hs_tmp_store+8(%rip), %rdi

    callq   _objc_msgSend

    // x0(originMethodReturn) = [self x0]
    movq	__hs_tmp_store+80(%rip), %rsi
    movq	__hs_tmp_store+8(%rip), %rdi
	movq	__hs_tmp_store+24(%rip), %rdx
	movq	__hs_tmp_store+32(%rip), %rcx
	movq	__hs_tmp_store+40(%rip), %r8
	movq	__hs_tmp_store+48(%rip), %r9
    // restore %xmm0~%xmm7 for floating-point arguments
    movsd   __hs_tmp_store+200(%rip), %xmm0
    movsd   __hs_tmp_store+216(%rip), %xmm1
    movsd   __hs_tmp_store+232(%rip), %xmm2
    movsd   __hs_tmp_store+248(%rip), %xmm3
    movsd   __hs_tmp_store+264(%rip), %xmm4
    movsd   __hs_tmp_store+280(%rip), %xmm5
    movsd   __hs_tmp_store+296(%rip), %xmm6
    movsd   __hs_tmp_store+312(%rip), %xmm7

    callq   _objc_msgSend
    movq	%rax, __hs_tmp_store+88(%rip)
    movsd   %xmm0, __hs_tmp_store+328(%rip)

    // [self hs_executeBlockAfterMethod:originSelector]
    movq	__hs_tmp_store+80(%rip), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.6(%rip), %rsi
    movq	__hs_tmp_store+8(%rip), %rdi

    callq   _objc_msgSend

    // restore (originMethodReturn) to return
    movq	__hs_tmp_store+88(%rip), %rax
    movsd   __hs_tmp_store+328(%rip), %xmm0
    // restore return address pointer and push to stack
    movq	__hs_tmp_store+72(%rip), %rdi
    pushq	%rdi

    retq


    .globl	_hs_switch_block_func_stret
	.align	4, 0x90
_hs_switch_block_func_stret:
    movq    %rbp, __hs_tmp_store(%rip) // save %rbp even though never changed
	movq	%rdi, __hs_tmp_store+8(%rip)
	movq	%rsi, __hs_tmp_store+16(%rip)
	movq	%rdx, __hs_tmp_store+24(%rip)
	movq	%rcx, __hs_tmp_store+32(%rip)
	movq	%r8, __hs_tmp_store+40(%rip)
	movq	%r9, __hs_tmp_store+48(%rip)

    // save %xmm0~%xmm7 for floating-point arguments
    movsd   %xmm0, __hs_tmp_store+200(%rip)
    movsd   %xmm1, __hs_tmp_store+216(%rip)
    movsd   %xmm2, __hs_tmp_store+232(%rip)
    movsd   %xmm3, __hs_tmp_store+248(%rip)
    movsd   %xmm4, __hs_tmp_store+264(%rip)
    movsd   %xmm5, __hs_tmp_store+280(%rip)
    movsd   %xmm6, __hs_tmp_store+296(%rip)
    movsd   %xmm7, __hs_tmp_store+312(%rip)

    // pop return address pointer from stack and save
    popq	%rax
    movq	%rax, __hs_tmp_store+72(%rip)

    // x0(originSelector) = [self hs_selectorForOriginMethod:x1]
    movq    __hs_tmp_store+16(%rip), %rdi
    movq    __hs_tmp_store+24(%rip), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.2(%rip), %rsi

    callq	_objc_msgSend
    movq	%rax, __hs_tmp_store+80(%rip)

    // [self hs_executeBlockBeforeMethod:originSelector]
    movq	__hs_tmp_store+80(%rip), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.4(%rip), %rsi
    movq	__hs_tmp_store+16(%rip), %rdi

    // x0(originMethodReturn) = [self x0]
    movq	__hs_tmp_store+16(%rip), %rsi
    movq	__hs_tmp_store+8(%rip), %rdi
	movq	__hs_tmp_store+80(%rip), %rdx
	movq	__hs_tmp_store+32(%rip), %rcx
	movq	__hs_tmp_store+40(%rip), %r8
	movq	__hs_tmp_store+48(%rip), %r9
    // restore %xmm0~%xmm7 for floating-point arguments
    movsd   __hs_tmp_store+200(%rip), %xmm0
    movsd   __hs_tmp_store+216(%rip), %xmm1
    movsd   __hs_tmp_store+232(%rip), %xmm2
    movsd   __hs_tmp_store+248(%rip), %xmm3
    movsd   __hs_tmp_store+264(%rip), %xmm4
    movsd   __hs_tmp_store+280(%rip), %xmm5
    movsd   __hs_tmp_store+296(%rip), %xmm6
    movsd   __hs_tmp_store+312(%rip), %xmm7

    callq   _objc_msgSend_stret
    // if struct size less than 16, %rax and %rdx store the return
    movq	%rax, __hs_tmp_store+88(%rip)
    movq	%rdx, __hs_tmp_store+96(%rip)

    // [self hs_executeBlockAfterMethod:originSelector]
    movq	__hs_tmp_store+80(%rip), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.6(%rip), %rsi
    movq	__hs_tmp_store+16(%rip), %rdi

    callq   _objc_msgSend

    // restore (originMethodReturn) to return
    movq	__hs_tmp_store+88(%rip), %rax
    movq	__hs_tmp_store+96(%rip), %rdx
    // restore return address pointer and push to stack
    movq	__hs_tmp_store+72(%rip), %rdi
    pushq	%rdi

    retq


    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.1:
	.asciz	"hs_selectorForOriginMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3
L_OBJC_SELECTOR_REFERENCES_.2:
	.quad	L_OBJC_METH_VAR_NAME_.1

    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.3:
	.asciz	"hs_executeBlockBeforeMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3
L_OBJC_SELECTOR_REFERENCES_.4:
	.quad	L_OBJC_METH_VAR_NAME_.3

    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.5:
	.asciz	"hs_executeBlockAfterMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3
L_OBJC_SELECTOR_REFERENCES_.6:
	.quad	L_OBJC_METH_VAR_NAME_.5


	.section	__DATA,__data
	.globl	__hs_tmp_store                  
	.align	4
__hs_tmp_store:
	.quad	1       // %rbp
	.quad	2       // %rdi~%r9
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10
    .quad	11      // replaceSelector
    .quad	12      // (return) %rax
    .quad	13      // (return) %rdx
    .quad	14
    .quad	15
    .quad	16
    .quad	1
	.quad	2
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10      // %xmm0~%xmm7
    .quad	11
    .quad	12
    .quad	13
    .quad	14
    .quad	15
    .quad	16
    .quad	1
	.quad	2
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10      // (return)%xmm0
    .quad	11
    .quad	12
    .quad	13
    .quad	14
    .quad	15
    .quad	16
    .quad	1
	.quad	2
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10
    .quad	11
    .quad	12
    .quad	13
    .quad	14
    .quad	15
    .quad	16

#endif
