/*
 * h_Controllers.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "h_Controllers".
 *
 * Model version              : 1.41
 * Simulink Coder version : 8.8 (R2015a) 09-Feb-2015
 * C++ source code generated on : Thu Oct 15 14:11:03 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_h_Controllers_h_
#define RTW_HEADER_h_Controllers_h_
#include <math.h>
#include <string.h>
#ifndef h_Controllers_COMMON_INCLUDES_
# define h_Controllers_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* h_Controllers_COMMON_INCLUDES_ */

#include "h_Controllers_types.h"

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
  real_T FilterCoefficient_c;          /* '<S2>/Filter Coefficient' */
  real_T Yawrate;                      /* '<S1>/Yaw-rate' */
  real_T FilterCoefficient_j;          /* '<S4>/Filter Coefficient' */
  real_T FilterCoefficient_d;          /* '<S5>/Filter Coefficient' */
  real_T FilterCoefficient_p;          /* '<S6>/Filter Coefficient' */
  real_T FilterCoefficient_jq;         /* '<S7>/Filter Coefficient' */
  real_T IntegralGain;                 /* '<S5>/Integral Gain' */
  real_T IntegralGain_o;               /* '<S6>/Integral Gain' */
  real_T IntegralGain_n;               /* '<S7>/Integral Gain' */
} B_h_Controllers_T;

/* Continuous states (auto storage) */
typedef struct {
  real_T Filter_CSTATE;                /* '<S3>/Filter' */
  real_T Filter_CSTATE_a;              /* '<S2>/Filter' */
  real_T Integrator_CSTATE;            /* '<S1>/Integrator' */
  real_T Filter_CSTATE_g;              /* '<S4>/Filter' */
  real_T Integrator_CSTATE_j;          /* '<S5>/Integrator' */
  real_T Filter_CSTATE_o;              /* '<S5>/Filter' */
  real_T Integrator_CSTATE_f;          /* '<S6>/Integrator' */
  real_T Filter_CSTATE_d;              /* '<S6>/Filter' */
  real_T Integrator_CSTATE_a;          /* '<S7>/Integrator' */
  real_T Filter_CSTATE_e;              /* '<S7>/Filter' */
} X_h_Controllers_T;

/* State derivatives (auto storage) */
typedef struct {
  real_T Filter_CSTATE;                /* '<S3>/Filter' */
  real_T Filter_CSTATE_a;              /* '<S2>/Filter' */
  real_T Integrator_CSTATE;            /* '<S1>/Integrator' */
  real_T Filter_CSTATE_g;              /* '<S4>/Filter' */
  real_T Integrator_CSTATE_j;          /* '<S5>/Integrator' */
  real_T Filter_CSTATE_o;              /* '<S5>/Filter' */
  real_T Integrator_CSTATE_f;          /* '<S6>/Integrator' */
  real_T Filter_CSTATE_d;              /* '<S6>/Filter' */
  real_T Integrator_CSTATE_a;          /* '<S7>/Integrator' */
  real_T Filter_CSTATE_e;              /* '<S7>/Filter' */
} XDot_h_Controllers_T;

/* State disabled  */
typedef struct {
  boolean_T Filter_CSTATE;             /* '<S3>/Filter' */
  boolean_T Filter_CSTATE_a;           /* '<S2>/Filter' */
  boolean_T Integrator_CSTATE;         /* '<S1>/Integrator' */
  boolean_T Filter_CSTATE_g;           /* '<S4>/Filter' */
  boolean_T Integrator_CSTATE_j;       /* '<S5>/Integrator' */
  boolean_T Filter_CSTATE_o;           /* '<S5>/Filter' */
  boolean_T Integrator_CSTATE_f;       /* '<S6>/Integrator' */
  boolean_T Filter_CSTATE_d;           /* '<S6>/Filter' */
  boolean_T Integrator_CSTATE_a;       /* '<S7>/Integrator' */
  boolean_T Filter_CSTATE_e;           /* '<S7>/Filter' */
} XDis_h_Controllers_T;

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
  real_T Stick[3];                     /* '<Root>/Stick' */
  real_T Rates[3];                     /* '<Root>/Rates' */
  real_T IMU_Attitude[3];              /* '<Root>/IMU_Attitude' */
  real_T IMU_Rates[3];                 /* '<Root>/IMU_Rates' */
} ExtU_h_Controllers_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T Moments[3];                   /* '<Root>/Moments' */
} ExtY_h_Controllers_T;

/* Parameters (auto storage) */
struct P_h_Controllers_T_ {
  real_T KPD;                          /* Variable: KPD
                                        * Referenced by: '<S2>/Derivative Gain'
                                        */
  real_T KPP;                          /* Variable: KPP
                                        * Referenced by: '<S2>/Proportional Gain'
                                        */
  real_T KRD;                          /* Variable: KRD
                                        * Referenced by: '<S3>/Derivative Gain'
                                        */
  real_T KRP;                          /* Variable: KRP
                                        * Referenced by: '<S3>/Proportional Gain'
                                        */
  real_T KYD;                          /* Variable: KYD
                                        * Referenced by: '<S4>/Derivative Gain'
                                        */
  real_T KYP;                          /* Variable: KYP
                                        * Referenced by: '<S4>/Proportional Gain'
                                        */
  real_T KYr;                          /* Variable: KYr
                                        * Referenced by: '<S1>/Yaw-rate'
                                        */
  real_T Kdp;                          /* Variable: Kdp
                                        * Referenced by: '<S5>/Derivative Gain'
                                        */
  real_T Kdq;                          /* Variable: Kdq
                                        * Referenced by: '<S6>/Derivative Gain'
                                        */
  real_T Kdr;                          /* Variable: Kdr
                                        * Referenced by: '<S7>/Derivative Gain'
                                        */
  real_T Kip;                          /* Variable: Kip
                                        * Referenced by: '<S5>/Integral Gain'
                                        */
  real_T Kiq;                          /* Variable: Kiq
                                        * Referenced by: '<S6>/Integral Gain'
                                        */
  real_T Kir;                          /* Variable: Kir
                                        * Referenced by: '<S7>/Integral Gain'
                                        */
  real_T Kpp;                          /* Variable: Kpp
                                        * Referenced by: '<S5>/Proportional Gain'
                                        */
  real_T Kpq;                          /* Variable: Kpq
                                        * Referenced by: '<S6>/Proportional Gain'
                                        */
  real_T Kpr;                          /* Variable: Kpr
                                        * Referenced by: '<S7>/Proportional Gain'
                                        */
  real_T N;                            /* Variable: N
                                        * Referenced by:
                                        *   '<S2>/Filter Coefficient'
                                        *   '<S3>/Filter Coefficient'
                                        *   '<S4>/Filter Coefficient'
                                        *   '<S5>/Filter Coefficient'
                                        *   '<S6>/Filter Coefficient'
                                        *   '<S7>/Filter Coefficient'
                                        */
  real_T pitchMax;                     /* Variable: pitchMax
                                        * Referenced by: '<S1>/Saturation1'
                                        */
  real_T pitchMin;                     /* Variable: pitchMin
                                        * Referenced by: '<S1>/Saturation1'
                                        */
  real_T rollMax;                      /* Variable: rollMax
                                        * Referenced by: '<S1>/Saturation'
                                        */
  real_T rollMin;                      /* Variable: rollMin
                                        * Referenced by: '<S1>/Saturation'
                                        */
  real_T Filter_IC;                    /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S3>/Filter'
                                        */
  real_T Filter_IC_i;                  /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
  real_T Integrator_IC;                /* Expression: 0
                                        * Referenced by: '<S1>/Integrator'
                                        */
  real_T Filter_IC_o;                  /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S4>/Filter'
                                        */
  real_T Integrator_IC_c;              /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S5>/Integrator'
                                        */
  real_T Filter_IC_a;                  /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S5>/Filter'
                                        */
  real_T Integrator_IC_l;              /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S6>/Integrator'
                                        */
  real_T Filter_IC_l;                  /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S6>/Filter'
                                        */
  real_T Integrator_IC_o;              /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S7>/Integrator'
                                        */
  real_T Filter_IC_c;                  /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S7>/Filter'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_h_Controllers_T {
  const char_T *errorStatus;
  RTWSolverInfo solverInfo;

  /*
   * ModelData:
   * The following substructure contains information regarding
   * the data used in the model.
   */
  struct {
    X_h_Controllers_T *contStates;
    int_T *periodicContStateIndices;
    real_T *periodicContStateRanges;
    real_T *derivs;
    boolean_T *contStateDisabled;
    boolean_T zCCacheNeedsReset;
    boolean_T derivCacheNeedsReset;
    boolean_T blkStateChange;
    real_T odeY[10];
    real_T odeF[2][10];
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

/* Class declaration for model h_Controllers */
class h_ControllersModelClass {
  /* public data and function members */
 public:
  /* External inputs */
  ExtU_h_Controllers_T h_Controllers_U;

  /* External outputs */
  ExtY_h_Controllers_T h_Controllers_Y;

  /* Model entry point functions */

  /* model initialize function */
  void initialize();

  /* model step function */
  void step();

  /* model terminate function */
  void terminate();

  /* Constructor */
  h_ControllersModelClass();

  /* Destructor */
  ~h_ControllersModelClass();

  /* Real-Time Model get method */
  RT_MODEL_h_Controllers_T * getRTM();

  /* private data and function members */
 private:
  /* Tunable parameters */
  P_h_Controllers_T h_Controllers_P;

  /* Block signals */
  B_h_Controllers_T h_Controllers_B;
  X_h_Controllers_T h_Controllers_X;   /* Block continuous states */

  /* Real-Time Model */
  RT_MODEL_h_Controllers_T h_Controllers_M;

  /* Continuous states update member function*/
  void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si );

  /* Derivatives member function */
  void h_Controllers_derivatives();
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
 * '<Root>' : 'h_Controllers'
 * '<S1>'   : 'h_Controllers/Attitude Controller'
 * '<S2>'   : 'h_Controllers/Attitude Controller/PID Pitch'
 * '<S3>'   : 'h_Controllers/Attitude Controller/PID Roll'
 * '<S4>'   : 'h_Controllers/Attitude Controller/PID Yaw'
 * '<S5>'   : 'h_Controllers/Attitude Controller/PID p'
 * '<S6>'   : 'h_Controllers/Attitude Controller/PID q'
 * '<S7>'   : 'h_Controllers/Attitude Controller/PID r'
 * '<S8>'   : 'h_Controllers/Attitude Controller/To body from Earth_rates'
 */
#endif                                 /* RTW_HEADER_h_Controllers_h_ */
