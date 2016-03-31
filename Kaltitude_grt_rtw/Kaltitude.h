/*
 * Kaltitude.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Kaltitude".
 *
 * Model version              : 1.91
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Wed Mar 30 12:44:15 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Kaltitude_h_
#define RTW_HEADER_Kaltitude_h_
#include <math.h>
#include <string.h>
#include <stddef.h>
#ifndef Kaltitude_COMMON_INCLUDES_
# define Kaltitude_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* Kaltitude_COMMON_INCLUDES_ */

#include "Kaltitude_types.h"

/* Shared type includes */
#include "multiword_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T UnitDelay_DSTATE[3];          /* '<S3>/Unit Delay' */
  real_T UnitDelay1_DSTATE[9];         /* '<S3>/Unit Delay1' */
} DW_Kaltitude_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T phi;                          /* '<Root>/phi' */
  real_T theta;                        /* '<Root>/theta' */
  real_T az;                           /* '<Root>/az' */
  real_T proxy;                        /* '<Root>/proxy' */
} ExtU_Kaltitude_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T state[3];                     /* '<Root>/state' */
} ExtY_Kaltitude_T;

/* Parameters (auto storage) */
struct P_Kaltitude_T_ {
  real_T UnitDelay_InitialCondition[3];/* Expression: zeros(3,1)
                                        * Referenced by: '<S3>/Unit Delay'
                                        */
  real_T Constant_Value;               /* Expression: 0.05
                                        * Referenced by: '<S3>/Constant'
                                        */
  real_T UnitDelay1_InitialCondition[9];/* Expression: eye(3)*0.001
                                         * Referenced by: '<S3>/Unit Delay1'
                                         */
  real_T Scalefactor_Gain;             /* Expression: 0.001
                                        * Referenced by: '<S1>/Scale factor'
                                        */
  real_T Constant1_Value[2];           /* Expression: [0;10.0675]
                                        * Referenced by: '<S3>/Constant1'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_Kaltitude_T {
  const char_T *errorStatus;
};

#ifdef __cplusplus

extern "C" {

#endif

#ifdef __cplusplus

}
#endif

/* Class declaration for model Kaltitude */
class KaltitudeModelClass {
  /* public data and function members */
 public:
  /* External inputs */
  ExtU_Kaltitude_T Kaltitude_U;

  /* External outputs */
  ExtY_Kaltitude_T Kaltitude_Y;

  /* Model entry point functions */

  /* model initialize function */
  void initialize();

  /* model step function */
  void step();

  /* model terminate function */
  void terminate();

  /* Constructor */
  KaltitudeModelClass();

  /* Destructor */
  ~KaltitudeModelClass();

  /* Real-Time Model get method */
  RT_MODEL_Kaltitude_T * getRTM();

  /* private data and function members */
 private:
  /* Tunable parameters */
  P_Kaltitude_T Kaltitude_P;

  /* Block states */
  DW_Kaltitude_T Kaltitude_DW;

  /* Real-Time Model */
  RT_MODEL_Kaltitude_T Kaltitude_M;
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
 * '<Root>' : 'Kaltitude'
 * '<S1>'   : 'Kaltitude/KALTITUDE'
 * '<S2>'   : 'Kaltitude/KALTITUDE/Acceleration Correction'
 * '<S3>'   : 'Kaltitude/KALTITUDE/KALTITUDE'
 * '<S4>'   : 'Kaltitude/KALTITUDE/KALTITUDE/Predict '
 * '<S5>'   : 'Kaltitude/KALTITUDE/KALTITUDE/Update'
 */
#endif                                 /* RTW_HEADER_Kaltitude_h_ */
