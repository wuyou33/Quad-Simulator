/*
 * g_Inverse_Dynamic.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "g_Inverse_Dynamic".
 *
 * Model version              : 1.10
 * Simulink Coder version : 8.8 (R2015a) 09-Feb-2015
 * C++ source code generated on : Wed Oct 28 19:33:46 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_g_Inverse_Dynamic_h_
#define RTW_HEADER_g_Inverse_Dynamic_h_
#include <math.h>
#include <stddef.h>
#include <string.h>
#ifndef g_Inverse_Dynamic_COMMON_INCLUDES_
# define g_Inverse_Dynamic_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* g_Inverse_Dynamic_COMMON_INCLUDES_ */

#include "g_Inverse_Dynamic_types.h"

/* Shared type includes */
#include "multiword_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T thrust;                       /* '<Root>/thrust' */
  real_T moment_x;                     /* '<Root>/moment_x' */
  real_T moment_y;                     /* '<Root>/moment_y' */
  real_T moment_z;                     /* '<Root>/moment_z' */
} ExtU_g_Inverse_Dynamic_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T th1;                          /* '<Root>/th1' */
  real_T th2;                          /* '<Root>/th2' */
  real_T th3;                          /* '<Root>/th3' */
  real_T th4;                          /* '<Root>/th4 ' */
} ExtY_g_Inverse_Dynamic_T;

/* Parameters (auto storage) */
struct P_g_Inverse_Dynamic_T_ {
  real_T Kinv[16];                     /* Variable: Kinv
                                        * Referenced by: '<S1>/Gain2'
                                        */
  real_T x1[2];                        /* Variable: x1
                                        * Referenced by:
                                        *   '<S1>/Bias1'
                                        *   '<S1>/Gain3'
                                        */
  real_T Saturation_UpperSat;          /* Expression: 100
                                        * Referenced by: '<S1>/Saturation'
                                        */
  real_T Saturation_LowerSat;          /* Expression: 0
                                        * Referenced by: '<S1>/Saturation'
                                        */
  real_T Saturation1_UpperSat;         /* Expression: 100
                                        * Referenced by: '<S1>/Saturation1'
                                        */
  real_T Saturation1_LowerSat;         /* Expression: 0
                                        * Referenced by: '<S1>/Saturation1'
                                        */
  real_T Saturation2_UpperSat;         /* Expression: 100
                                        * Referenced by: '<S1>/Saturation2'
                                        */
  real_T Saturation2_LowerSat;         /* Expression: 0
                                        * Referenced by: '<S1>/Saturation2'
                                        */
  real_T Saturation3_UpperSat;         /* Expression: 100
                                        * Referenced by: '<S1>/Saturation3'
                                        */
  real_T Saturation3_LowerSat;         /* Expression: 0
                                        * Referenced by: '<S1>/Saturation3'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_g_Inverse_Dynamic_T {
  const char_T *errorStatus;
};

#ifdef __cplusplus

extern "C" {

#endif

#ifdef __cplusplus

}
#endif

/* Class declaration for model g_Inverse_Dynamic */
class g_Inverse_DynamicModelClass {
  /* public data and function members */
 public:
  /* External inputs */
  ExtU_g_Inverse_Dynamic_T g_Inverse_Dynamic_U;

  /* External outputs */
  ExtY_g_Inverse_Dynamic_T g_Inverse_Dynamic_Y;

  /* Model entry point functions */

  /* model initialize function */
  void initialize();

  /* model step function */
  void step();

  /* model terminate function */
  void terminate();

  /* Constructor */
  g_Inverse_DynamicModelClass();

  /* Destructor */
  ~g_Inverse_DynamicModelClass();

  /* Real-Time Model get method */
  RT_MODEL_g_Inverse_Dynamic_T * getRTM();

  /* private data and function members */
 private:
  /* Tunable parameters */
  P_g_Inverse_Dynamic_T g_Inverse_Dynamic_P;

  /* Real-Time Model */
  RT_MODEL_g_Inverse_Dynamic_T g_Inverse_Dynamic_M;
};

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'g_Inverse_Dynamic'
 * '<S1>'   : 'g_Inverse_Dynamic/Inverse Dynamic'
 */
#endif                                 /* RTW_HEADER_g_Inverse_Dynamic_h_ */
