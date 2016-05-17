/*
 * Position.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Position".
 *
 * Model version              : 1.91
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Tue May 17 12:12:34 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Position_h_
#define RTW_HEADER_Position_h_
#include <math.h>
#include <string.h>
#ifndef Position_COMMON_INCLUDES_
# define Position_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* Position_COMMON_INCLUDES_ */

#include "Position_types.h"

/* Shared type includes */
#include "multiword_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetBlkStateChangeFlag
# define rtmGetBlkStateChangeFlag(rtm) ((rtm)->ModelData.blkStateChange)
#endif

#ifndef rtmSetBlkStateChangeFlag
# define rtmSetBlkStateChangeFlag(rtm, val) ((rtm)->ModelData.blkStateChange = (val))
#endif

#ifndef rtmGetContStateDisabled
# define rtmGetContStateDisabled(rtm)  ((rtm)->ModelData.contStateDisabled)
#endif

#ifndef rtmSetContStateDisabled
# define rtmSetContStateDisabled(rtm, val) ((rtm)->ModelData.contStateDisabled = (val))
#endif

#ifndef rtmGetContStates
# define rtmGetContStates(rtm)         ((rtm)->ModelData.contStates)
#endif

#ifndef rtmSetContStates
# define rtmSetContStates(rtm, val)    ((rtm)->ModelData.contStates = (val))
#endif

#ifndef rtmGetDerivCacheNeedsReset
# define rtmGetDerivCacheNeedsReset(rtm) ((rtm)->ModelData.derivCacheNeedsReset)
#endif

#ifndef rtmSetDerivCacheNeedsReset
# define rtmSetDerivCacheNeedsReset(rtm, val) ((rtm)->ModelData.derivCacheNeedsReset = (val))
#endif

#ifndef rtmGetIntgData
# define rtmGetIntgData(rtm)           ((rtm)->ModelData.intgData)
#endif

#ifndef rtmSetIntgData
# define rtmSetIntgData(rtm, val)      ((rtm)->ModelData.intgData = (val))
#endif

#ifndef rtmGetOdeF
# define rtmGetOdeF(rtm)               ((rtm)->ModelData.odeF)
#endif

#ifndef rtmSetOdeF
# define rtmSetOdeF(rtm, val)          ((rtm)->ModelData.odeF = (val))
#endif

#ifndef rtmGetOdeY
# define rtmGetOdeY(rtm)               ((rtm)->ModelData.odeY)
#endif

#ifndef rtmSetOdeY
# define rtmSetOdeY(rtm, val)          ((rtm)->ModelData.odeY = (val))
#endif

#ifndef rtmGetPeriodicContStateIndices
# define rtmGetPeriodicContStateIndices(rtm) ((rtm)->ModelData.periodicContStateIndices)
#endif

#ifndef rtmSetPeriodicContStateIndices
# define rtmSetPeriodicContStateIndices(rtm, val) ((rtm)->ModelData.periodicContStateIndices = (val))
#endif

#ifndef rtmGetPeriodicContStateRanges
# define rtmGetPeriodicContStateRanges(rtm) ((rtm)->ModelData.periodicContStateRanges)
#endif

#ifndef rtmSetPeriodicContStateRanges
# define rtmSetPeriodicContStateRanges(rtm, val) ((rtm)->ModelData.periodicContStateRanges = (val))
#endif

#ifndef rtmGetZCCacheNeedsReset
# define rtmGetZCCacheNeedsReset(rtm)  ((rtm)->ModelData.zCCacheNeedsReset)
#endif

#ifndef rtmSetZCCacheNeedsReset
# define rtmSetZCCacheNeedsReset(rtm, val) ((rtm)->ModelData.zCCacheNeedsReset = (val))
#endif

#ifndef rtmGetdX
# define rtmGetdX(rtm)                 ((rtm)->ModelData.derivs)
#endif

#ifndef rtmSetdX
# define rtmSetdX(rtm, val)            ((rtm)->ModelData.derivs = (val))
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  (rtmGetTPtr((rtm))[0])
#endif

/* Block signals (auto storage) */
typedef struct {
  real_T FilterCoefficient;            /* '<S3>/Filter Coefficient' */
  real_T FilterCoefficient_d;          /* '<S2>/Filter Coefficient' */
  real_T IntegralGain;                 /* '<S2>/Integral Gain' */
  real_T IntegralGain_p;               /* '<S3>/Integral Gain' */
} B_Position_T;

/* Continuous states (auto storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<S3>/Integrator' */
  real_T Filter_CSTATE;                /* '<S3>/Filter' */
  real_T Integrator_CSTATE_d;          /* '<S2>/Integrator' */
  real_T Filter_CSTATE_i;              /* '<S2>/Filter' */
} X_Position_T;

/* State derivatives (auto storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<S3>/Integrator' */
  real_T Filter_CSTATE;                /* '<S3>/Filter' */
  real_T Integrator_CSTATE_d;          /* '<S2>/Integrator' */
  real_T Filter_CSTATE_i;              /* '<S2>/Filter' */
} XDot_Position_T;

/* State disabled  */
typedef struct {
  boolean_T Integrator_CSTATE;         /* '<S3>/Integrator' */
  boolean_T Filter_CSTATE;             /* '<S3>/Filter' */
  boolean_T Integrator_CSTATE_d;       /* '<S2>/Integrator' */
  boolean_T Filter_CSTATE_i;           /* '<S2>/Filter' */
} XDis_Position_T;

#ifndef ODE2_INTG
#define ODE2_INTG

/* ODE2 Integration Data */
typedef struct {
  real_T *y;                           /* output */
  real_T *f[2];                        /* derivatives */
} ODE2_IntgData;

#endif

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T PosDes[2];                    /* '<Root>/PosDes' */
  real_T Pos[2];                       /* '<Root>/Pos' */
  real_T IMU_Attitude[3];              /* '<Root>/IMU_Attitude' */
} ExtU_Position_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T Ro;                           /* '<Root>/Ro' */
  real_T Po;                           /* '<Root>/Po' */
} ExtY_Position_T;

/* Parameters (auto storage) */
struct P_Position_T_ {
  real_T KD_pos;                       /* Variable: KD_pos
                                        * Referenced by:
                                        *   '<S2>/Derivative Gain'
                                        *   '<S3>/Derivative Gain'
                                        */
  real_T KI_pos;                       /* Variable: KI_pos
                                        * Referenced by:
                                        *   '<S2>/Integral Gain'
                                        *   '<S3>/Integral Gain'
                                        */
  real_T KN_pos;                       /* Variable: KN_pos
                                        * Referenced by:
                                        *   '<S2>/Filter Coefficient'
                                        *   '<S3>/Filter Coefficient'
                                        */
  real_T KP_pos;                       /* Variable: KP_pos
                                        * Referenced by:
                                        *   '<S2>/Proportional Gain'
                                        *   '<S3>/Proportional Gain'
                                        */
  real_T pitchMax;                     /* Variable: pitchMax
                                        * Referenced by:
                                        *   '<S1>/NormalizePitch'
                                        *   '<S2>/Saturate'
                                        */
  real_T rollMax;                      /* Variable: rollMax
                                        * Referenced by:
                                        *   '<S1>/NormalizeRoll'
                                        *   '<S3>/Saturate'
                                        */
  real_T Integrator_IC;                /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S3>/Integrator'
                                        */
  real_T Filter_IC;                    /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S3>/Filter'
                                        */
  real_T Integrator_IC_a;              /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S2>/Integrator'
                                        */
  real_T Filter_IC_h;                  /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_Position_T {
  const char_T *errorStatus;
  RTWSolverInfo solverInfo;

  /*
   * ModelData:
   * The following substructure contains information regarding
   * the data used in the model.
   */
  struct {
    X_Position_T *contStates;
    int_T *periodicContStateIndices;
    real_T *periodicContStateRanges;
    real_T *derivs;
    boolean_T *contStateDisabled;
    boolean_T zCCacheNeedsReset;
    boolean_T derivCacheNeedsReset;
    boolean_T blkStateChange;
    real_T odeY[4];
    real_T odeF[2][4];
    ODE2_IntgData intgData;
  } ModelData;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    int_T numContStates;
    int_T numPeriodicContStates;
    int_T numSampTimes;
  } Sizes;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    uint32_T clockTick1;
    uint32_T clockTickH1;
    SimTimeStep simTimeStep;
    boolean_T stopRequestedFlag;
    time_T *t;
    time_T tArray[2];
  } Timing;
};

#ifdef __cplusplus

extern "C" {

#endif

#ifdef __cplusplus

}
#endif

/* Class declaration for model Position */
class PositionModelClass {
  /* public data and function members */
 public:
  /* External inputs */
  ExtU_Position_T Position_U;

  /* External outputs */
  ExtY_Position_T Position_Y;

  /* Model entry point functions */

  /* model initialize function */
  void initialize();

  /* model step function */
  void step();

  /* model terminate function */
  void terminate();

  /* Constructor */
  PositionModelClass();

  /* Destructor */
  ~PositionModelClass();

  /* Real-Time Model get method */
  RT_MODEL_Position_T * getRTM();

  /* private data and function members */
 private:
  /* Tunable parameters */
  P_Position_T Position_P;

  /* Block signals */
  B_Position_T Position_B;
  X_Position_T Position_X;             /* Block continuous states */

  /* Real-Time Model */
  RT_MODEL_Position_T Position_M;

  /* Continuous states update member function*/
  void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si );

  /* Derivatives member function */
  void Position_derivatives();
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
 * '<Root>' : 'Position'
 * '<S1>'   : 'Position/Position Controller'
 * '<S2>'   : 'Position/Position Controller/PID Controller'
 * '<S3>'   : 'Position/Position Controller/PID Controller1'
 * '<S4>'   : 'Position/Position Controller/To body from Earth'
 */
#endif                                 /* RTW_HEADER_Position_h_ */
