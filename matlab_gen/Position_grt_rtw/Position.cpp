/*
 * Position.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Position".
 *
 * Model version              : 1.91
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Tue May 17 12:31:32 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "Position.h"
#include "Position_private.h"

/*
 * This function updates continuous states using the ODE2 fixed-step
 * solver algorithm
 */
void PositionModelClass::rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE2_IntgData *id = (ODE2_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T temp;
  int_T i;
  int_T nXc = 4;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Position_derivatives();

  /* f1 = f(t + h, y + h*f0) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (h*f0[i]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f1);
  this->step();
  Position_derivatives();

  /* tnew = t + h
     ynew = y + (h/2)*(f0 + f1) */
  temp = 0.5*h;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + f1[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void PositionModelClass::step()
{
  real_T Spsi;
  real_T Cpsi;
  real_T tmp;
  real_T tmp_0;
  real_T rtb_body_idx_0;
  if (rtmIsMajorTimeStep((&Position_M))) {
    /* set solver stop time */
    if (!((&Position_M)->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&(&Position_M)->solverInfo, (((&Position_M)
        ->Timing.clockTickH0 + 1) * (&Position_M)->Timing.stepSize0 *
        4294967296.0));
    } else {
      rtsiSetSolverStopTime(&(&Position_M)->solverInfo, (((&Position_M)
        ->Timing.clockTick0 + 1) * (&Position_M)->Timing.stepSize0 +
        (&Position_M)->Timing.clockTickH0 * (&Position_M)->Timing.stepSize0 *
        4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep((&Position_M))) {
    (&Position_M)->Timing.t[0] = rtsiGetT(&(&Position_M)->solverInfo);
  }

  /* MATLAB Function: '<S1>/To body from Earth' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   */
  /* MATLAB Function 'Position Controller/To body from Earth': '<S4>:1' */
  /* '<S4>:1:5' */
  Spsi = sin(Position_U.IMU_Attitude[2]);

  /* '<S4>:1:6' */
  Cpsi = cos(Position_U.IMU_Attitude[2]);

  /* SignalConversion: '<S4>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Inport: '<Root>/Pos'
   *  Inport: '<Root>/PosDes'
   *  MATLAB Function: '<S1>/To body from Earth'
   *  Sum: '<S1>/Sum'
   *  Sum: '<S1>/Sum1'
   */
  /* '<S4>:1:8' */
  /* '<S4>:1:11' */
  tmp = Position_U.PosDes[0] - Position_U.Pos[0];
  tmp_0 = Position_U.PosDes[1] - Position_U.Pos[1];

  /* MATLAB Function: '<S1>/To body from Earth' */
  rtb_body_idx_0 = Cpsi * tmp + Spsi * tmp_0;
  Spsi = -Spsi * tmp + Cpsi * tmp_0;

  /* Gain: '<S3>/Filter Coefficient' incorporates:
   *  Gain: '<S3>/Derivative Gain'
   *  Integrator: '<S3>/Filter'
   *  Sum: '<S3>/SumD'
   */
  Position_B.FilterCoefficient = (Position_P.KD_pos * Spsi -
    Position_X.Filter_CSTATE) * Position_P.KN_pos;

  /* Sum: '<S3>/Sum' incorporates:
   *  Gain: '<S3>/Proportional Gain'
   *  Integrator: '<S3>/Integrator'
   */
  Cpsi = (Position_P.KP_pos * Spsi + Position_X.Integrator_CSTATE) +
    Position_B.FilterCoefficient;

  /* Saturate: '<S3>/Saturate' */
  if (Cpsi > Position_P.rollMax) {
    Cpsi = Position_P.rollMax;
  } else {
    if (Cpsi < -Position_P.rollMax) {
      Cpsi = -Position_P.rollMax;
    }
  }

  /* Outport: '<Root>/Ro' incorporates:
   *  Gain: '<S1>/NormalizeRoll'
   *  Saturate: '<S3>/Saturate'
   */
  Position_Y.Ro = 1.0 / Position_P.rollMax * Cpsi;

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  Gain: '<S2>/Derivative Gain'
   *  Integrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  Position_B.FilterCoefficient_d = (Position_P.KD_pos * rtb_body_idx_0 -
    Position_X.Filter_CSTATE_i) * Position_P.KN_pos;

  /* Sum: '<S2>/Sum' incorporates:
   *  Gain: '<S2>/Proportional Gain'
   *  Integrator: '<S2>/Integrator'
   */
  Cpsi = (Position_P.KP_pos * rtb_body_idx_0 + Position_X.Integrator_CSTATE_d) +
    Position_B.FilterCoefficient_d;

  /* Saturate: '<S2>/Saturate' */
  if (Cpsi > Position_P.pitchMax) {
    Cpsi = Position_P.pitchMax;
  } else {
    if (Cpsi < -Position_P.pitchMax) {
      Cpsi = -Position_P.pitchMax;
    }
  }

  /* Outport: '<Root>/Po' incorporates:
   *  Gain: '<S1>/NormalizePitch'
   *  Saturate: '<S2>/Saturate'
   */
  Position_Y.Po = -1.0 / Position_P.pitchMax * Cpsi;

  /* Gain: '<S2>/Integral Gain' */
  Position_B.IntegralGain = Position_P.KI_pos * rtb_body_idx_0;

  /* Gain: '<S3>/Integral Gain' */
  Position_B.IntegralGain_p = Position_P.KI_pos * Spsi;
  if (rtmIsMajorTimeStep((&Position_M))) {
    rt_ertODEUpdateContinuousStates(&(&Position_M)->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++(&Position_M)->Timing.clockTick0)) {
      ++(&Position_M)->Timing.clockTickH0;
    }

    (&Position_M)->Timing.t[0] = rtsiGetSolverStopTime(&(&Position_M)
      ->solverInfo);

    {
      /* Update absolute timer for sample time: [0.01s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 0.01, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      (&Position_M)->Timing.clockTick1++;
      if (!(&Position_M)->Timing.clockTick1) {
        (&Position_M)->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void PositionModelClass::Position_derivatives()
{
  XDot_Position_T *_rtXdot;
  _rtXdot = ((XDot_Position_T *) (&Position_M)->ModelData.derivs);

  /* Derivatives for Integrator: '<S3>/Integrator' */
  _rtXdot->Integrator_CSTATE = Position_B.IntegralGain_p;

  /* Derivatives for Integrator: '<S3>/Filter' */
  _rtXdot->Filter_CSTATE = Position_B.FilterCoefficient;

  /* Derivatives for Integrator: '<S2>/Integrator' */
  _rtXdot->Integrator_CSTATE_d = Position_B.IntegralGain;

  /* Derivatives for Integrator: '<S2>/Filter' */
  _rtXdot->Filter_CSTATE_i = Position_B.FilterCoefficient_d;
}

/* Model initialize function */
void PositionModelClass::initialize()
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)(&Position_M), 0,
                sizeof(RT_MODEL_Position_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&(&Position_M)->solverInfo, &(&Position_M)
                          ->Timing.simTimeStep);
    rtsiSetTPtr(&(&Position_M)->solverInfo, &rtmGetTPtr((&Position_M)));
    rtsiSetStepSizePtr(&(&Position_M)->solverInfo, &(&Position_M)
                       ->Timing.stepSize0);
    rtsiSetdXPtr(&(&Position_M)->solverInfo, &(&Position_M)->ModelData.derivs);
    rtsiSetContStatesPtr(&(&Position_M)->solverInfo, (real_T **) &(&Position_M
                         )->ModelData.contStates);
    rtsiSetNumContStatesPtr(&(&Position_M)->solverInfo, &(&Position_M)
      ->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&(&Position_M)->solverInfo, (&rtmGetErrorStatus
      ((&Position_M))));
    rtsiSetRTModelPtr(&(&Position_M)->solverInfo, (&Position_M));
  }

  rtsiSetSimTimeStep(&(&Position_M)->solverInfo, MAJOR_TIME_STEP);
  (&Position_M)->ModelData.intgData.y = (&Position_M)->ModelData.odeY;
  (&Position_M)->ModelData.intgData.f[0] = (&Position_M)->ModelData.odeF[0];
  (&Position_M)->ModelData.intgData.f[1] = (&Position_M)->ModelData.odeF[1];
  (&Position_M)->ModelData.contStates = ((X_Position_T *) &Position_X);
  rtsiSetSolverData(&(&Position_M)->solverInfo, (void *)&(&Position_M)
                    ->ModelData.intgData);
  rtsiSetSolverName(&(&Position_M)->solverInfo,"ode2");
  rtmSetTPtr((&Position_M), &(&Position_M)->Timing.tArray[0]);
  (&Position_M)->Timing.stepSize0 = 0.01;

  /* block I/O */
  (void) memset(((void *) &Position_B), 0,
                sizeof(B_Position_T));

  /* states (continuous) */
  {
    (void) memset((void *)&Position_X, 0,
                  sizeof(X_Position_T));
  }

  /* external inputs */
  (void) memset((void *)&Position_U, 0,
                sizeof(ExtU_Position_T));

  /* external outputs */
  (void) memset((void *)&Position_Y, 0,
                sizeof(ExtY_Position_T));

  /* InitializeConditions for Integrator: '<S3>/Integrator' */
  Position_X.Integrator_CSTATE = Position_P.Integrator_IC;

  /* InitializeConditions for Integrator: '<S3>/Filter' */
  Position_X.Filter_CSTATE = Position_P.Filter_IC;

  /* InitializeConditions for Integrator: '<S2>/Integrator' */
  Position_X.Integrator_CSTATE_d = Position_P.Integrator_IC_a;

  /* InitializeConditions for Integrator: '<S2>/Filter' */
  Position_X.Filter_CSTATE_i = Position_P.Filter_IC_h;
}

/* Model terminate function */
void PositionModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
PositionModelClass::PositionModelClass()
{
  static const P_Position_T Position_P_temp = {
    0.0783,                            /* Variable: KD_pos
                                        * Referenced by:
                                        *   '<S2>/Derivative Gain'
                                        *   '<S3>/Derivative Gain'
                                        */
    0.0021000000000000003,             /* Variable: KI_pos
                                        * Referenced by:
                                        *   '<S2>/Integral Gain'
                                        *   '<S3>/Integral Gain'
                                        */
    83.333333333333329,                /* Variable: KN_pos
                                        * Referenced by:
                                        *   '<S2>/Filter Coefficient'
                                        *   '<S3>/Filter Coefficient'
                                        */
    0.0379,                            /* Variable: KP_pos
                                        * Referenced by:
                                        *   '<S2>/Proportional Gain'
                                        *   '<S3>/Proportional Gain'
                                        */
    0.52359877559829882,               /* Variable: pitchMax
                                        * Referenced by:
                                        *   '<S1>/NormalizePitch'
                                        *   '<S2>/Saturate'
                                        */
    0.52359877559829882,               /* Variable: rollMax
                                        * Referenced by:
                                        *   '<S1>/NormalizeRoll'
                                        *   '<S3>/Saturate'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S3>/Integrator'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S3>/Filter'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S2>/Integrator'
                                        */
    0.0                                /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
  };                                   /* Modifiable parameters */

  /* Initialize tunable parameters */
  Position_P = Position_P_temp;
}

/* Destructor */
PositionModelClass::~PositionModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_Position_T * PositionModelClass::getRTM()
{
  return (&Position_M);
}
