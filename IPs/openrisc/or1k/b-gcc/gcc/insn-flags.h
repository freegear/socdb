/* Generated automatically by the program `genflags'
   from the machine description file `md'.  */

#ifndef GCC_INSN_FLAGS_H
#define GCC_INSN_FLAGS_H

#define HAVE_return_internal (TARGET_SCHED_LOGUE)
#define HAVE_sibcall_internal (TARGET_SIBCALL)
#define HAVE_movsi_insn_big (GET_CODE(operands[1]) != CONST_INT)
#define HAVE_cmov (TARGET_CMOV)
#define HAVE_movdi 1
#define HAVE_movdf 1
#define HAVE_movsf 1
#define HAVE_extendqisi2_sext (TARGET_SEXT)
#define HAVE_extendqisi2_no_sext_mem (!TARGET_SEXT)
#define HAVE_extendhisi2_sext (TARGET_SEXT)
#define HAVE_extendhisi2_no_sext_mem (!TARGET_SEXT)
#define HAVE_zero_extendqisi2 1
#define HAVE_zero_extendhisi2 1
#define HAVE_ashlsi3 1
#define HAVE_ashrsi3 1
#define HAVE_lshrsi3 1
#define HAVE_rotrsi3 (TARGET_ROR)
#define HAVE_andsi3 1
#define HAVE_iorsi3 1
#define HAVE_xorsi3 1
#define HAVE_one_cmplqi2 1
#define HAVE_one_cmplsi2 1
#define HAVE_negsi2 1
#define HAVE_addsi3 1
#define HAVE_subsi3 1
#define HAVE_mulsi3 (TARGET_HARD_MUL)
#define HAVE_divsi3 (TARGET_HARD_DIV)
#define HAVE_udivsi3 (TARGET_HARD_DIV)
#define HAVE_jump_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_jump_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_indirect_jump_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_indirect_jump_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_call_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_call_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_call_value_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_call_value_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_call_value_indirect_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_call_value_indirect_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_call_indirect_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_call_indirect_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_tablejump_internal (!TARGET_ALIGNED_JUMPS)
#define HAVE_tablejump_aligned (TARGET_ALIGNED_JUMPS)
#define HAVE_nop 1
#define HAVE_addsf3 (TARGET_HARD_FLOAT)
#define HAVE_adddf3 (TARGET_HARD_FLOAT)
#define HAVE_subsf3 (TARGET_HARD_FLOAT)
#define HAVE_subdf3 (TARGET_HARD_FLOAT)
#define HAVE_mulsf3 (TARGET_HARD_FLOAT)
#define HAVE_muldf3 (TARGET_HARD_FLOAT)
#define HAVE_divsf3 (TARGET_HARD_FLOAT)
#define HAVE_divdf3 (TARGET_HARD_FLOAT)
#define HAVE_prologue (TARGET_SCHED_LOGUE)
#define HAVE_epilogue (TARGET_SCHED_LOGUE)
#define HAVE_sibcall_epilogue (TARGET_SCHED_LOGUE)
#define HAVE_sibcall (TARGET_SIBCALL)
#define HAVE_sibcall_value (TARGET_SIBCALL)
#define HAVE_movqi 1
#define HAVE_movhi 1
#define HAVE_movsi 1
#define HAVE_addsicc 1
#define HAVE_addhicc 1
#define HAVE_addqicc 1
#define HAVE_movsicc (TARGET_CMOV)
#define HAVE_movhicc 1
#define HAVE_movqicc 1
#define HAVE_cmpsi 1
#define HAVE_beq 1
#define HAVE_bne 1
#define HAVE_bgt 1
#define HAVE_bgtu 1
#define HAVE_blt 1
#define HAVE_bltu 1
#define HAVE_bge 1
#define HAVE_bgeu 1
#define HAVE_ble 1
#define HAVE_bleu 1
#define HAVE_extendqisi2 1
#define HAVE_extendqisi2_no_sext_reg (!TARGET_SEXT)
#define HAVE_extendhisi2 1
#define HAVE_extendhisi2_no_sext_reg (!TARGET_SEXT)
#define HAVE_jump 1
#define HAVE_indirect_jump 1
#define HAVE_call 1
#define HAVE_call_value 1
#define HAVE_call_value_indirect 1
#define HAVE_call_indirect 1
#define HAVE_tablejump 1
extern rtx        gen_return_internal              (rtx);
extern rtx        gen_sibcall_internal             (rtx, rtx);
extern rtx        gen_movsi_insn_big               (rtx, rtx);
extern rtx        gen_cmov                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_movdi                        (rtx, rtx);
extern rtx        gen_movdf                        (rtx, rtx);
extern rtx        gen_movsf                        (rtx, rtx);
extern rtx        gen_extendqisi2_sext             (rtx, rtx);
extern rtx        gen_extendqisi2_no_sext_mem      (rtx, rtx);
extern rtx        gen_extendhisi2_sext             (rtx, rtx);
extern rtx        gen_extendhisi2_no_sext_mem      (rtx, rtx);
extern rtx        gen_zero_extendqisi2             (rtx, rtx);
extern rtx        gen_zero_extendhisi2             (rtx, rtx);
extern rtx        gen_ashlsi3                      (rtx, rtx, rtx);
extern rtx        gen_ashrsi3                      (rtx, rtx, rtx);
extern rtx        gen_lshrsi3                      (rtx, rtx, rtx);
extern rtx        gen_rotrsi3                      (rtx, rtx, rtx);
extern rtx        gen_andsi3                       (rtx, rtx, rtx);
extern rtx        gen_iorsi3                       (rtx, rtx, rtx);
extern rtx        gen_xorsi3                       (rtx, rtx, rtx);
extern rtx        gen_one_cmplqi2                  (rtx, rtx);
extern rtx        gen_one_cmplsi2                  (rtx, rtx);
extern rtx        gen_negsi2                       (rtx, rtx);
extern rtx        gen_addsi3                       (rtx, rtx, rtx);
extern rtx        gen_subsi3                       (rtx, rtx, rtx);
extern rtx        gen_mulsi3                       (rtx, rtx, rtx);
extern rtx        gen_divsi3                       (rtx, rtx, rtx);
extern rtx        gen_udivsi3                      (rtx, rtx, rtx);
extern rtx        gen_jump_internal                (rtx);
extern rtx        gen_jump_aligned                 (rtx);
extern rtx        gen_indirect_jump_internal       (rtx);
extern rtx        gen_indirect_jump_aligned        (rtx);
extern rtx        gen_call_internal                (rtx, rtx);
extern rtx        gen_call_aligned                 (rtx, rtx);
extern rtx        gen_call_value_internal          (rtx, rtx, rtx);
extern rtx        gen_call_value_aligned           (rtx, rtx, rtx);
extern rtx        gen_call_value_indirect_internal (rtx, rtx, rtx);
extern rtx        gen_call_value_indirect_aligned  (rtx, rtx, rtx);
extern rtx        gen_call_indirect_internal       (rtx, rtx);
extern rtx        gen_call_indirect_aligned        (rtx, rtx);
extern rtx        gen_tablejump_internal           (rtx, rtx);
extern rtx        gen_tablejump_aligned            (rtx, rtx);
extern rtx        gen_nop                          (void);
extern rtx        gen_addsf3                       (rtx, rtx, rtx);
extern rtx        gen_adddf3                       (rtx, rtx, rtx);
extern rtx        gen_subsf3                       (rtx, rtx, rtx);
extern rtx        gen_subdf3                       (rtx, rtx, rtx);
extern rtx        gen_mulsf3                       (rtx, rtx, rtx);
extern rtx        gen_muldf3                       (rtx, rtx, rtx);
extern rtx        gen_divsf3                       (rtx, rtx, rtx);
extern rtx        gen_divdf3                       (rtx, rtx, rtx);
extern rtx        gen_prologue                     (void);
extern rtx        gen_epilogue                     (void);
extern rtx        gen_sibcall_epilogue             (void);
#define GEN_SIBCALL(A, B, C, D) gen_sibcall ((A), (B), (C), (D))
extern rtx        gen_sibcall                      (rtx, rtx, rtx, rtx);
#define GEN_SIBCALL_VALUE(A, B, C, D, E) gen_sibcall_value ((A), (B), (C))
extern rtx        gen_sibcall_value                (rtx, rtx, rtx);
extern rtx        gen_movqi                        (rtx, rtx);
extern rtx        gen_movhi                        (rtx, rtx);
extern rtx        gen_movsi                        (rtx, rtx);
extern rtx        gen_addsicc                      (rtx, rtx, rtx, rtx);
extern rtx        gen_addhicc                      (rtx, rtx, rtx, rtx);
extern rtx        gen_addqicc                      (rtx, rtx, rtx, rtx);
extern rtx        gen_movsicc                      (rtx, rtx, rtx, rtx);
extern rtx        gen_movhicc                      (rtx, rtx, rtx, rtx);
extern rtx        gen_movqicc                      (rtx, rtx, rtx, rtx);
extern rtx        gen_cmpsi                        (rtx, rtx);
extern rtx        gen_beq                          (rtx);
extern rtx        gen_bne                          (rtx);
extern rtx        gen_bgt                          (rtx);
extern rtx        gen_bgtu                         (rtx);
extern rtx        gen_blt                          (rtx);
extern rtx        gen_bltu                         (rtx);
extern rtx        gen_bge                          (rtx);
extern rtx        gen_bgeu                         (rtx);
extern rtx        gen_ble                          (rtx);
extern rtx        gen_bleu                         (rtx);
extern rtx        gen_extendqisi2                  (rtx, rtx);
extern rtx        gen_extendqisi2_no_sext_reg      (rtx, rtx);
extern rtx        gen_extendhisi2                  (rtx, rtx);
extern rtx        gen_extendhisi2_no_sext_reg      (rtx, rtx);
extern rtx        gen_jump                         (rtx);
extern rtx        gen_indirect_jump                (rtx);
#define GEN_CALL(A, B, C, D) gen_call ((A), (B))
extern rtx        gen_call                         (rtx, rtx);
#define GEN_CALL_VALUE(A, B, C, D, E) gen_call_value ((A), (B), (C))
extern rtx        gen_call_value                   (rtx, rtx, rtx);
extern rtx        gen_call_value_indirect          (rtx, rtx, rtx);
extern rtx        gen_call_indirect                (rtx, rtx);
extern rtx        gen_tablejump                    (rtx, rtx);

#endif /* GCC_INSN_FLAGS_H */
