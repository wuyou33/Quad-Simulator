/*
 * h_Controllers.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "h_Controllers".
 *
 * Model version              : 1.41
 * Simulink Coder version : 8.8 (R2015a) 09-Feb-2015
 * C++ source code generated on : Wed Oct 14 11:46:05 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "h_Controllers.h"
#include "h_Controllers_private.h"

/*
 * This function updates continuous states using the ODE2 fixed-step
 * solver algorithm
 */
void h_ControllersModelClass::rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
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
  int_T nXc = 10;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  h_Controllers_derivatives();

  /* f1 = f(t + h, y + h*f0) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (h*f0[i]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f1);
  this->step();
  h_Controllers_derivatives();

  /* tnew = t + h
     ynew = y + (h/2)*(f0 + f1) */
  temp = 0.5*h;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + f1[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void h_ControllersModelClass::step()
{
  real_T Sphi;
  real_T Cphi;
  real_T Ctheta;
  real_T rtb_Sum4;
  real_T rtb_ProportionalGain;
  real_T rtb_ProportionalGain_g;
  real_T rtb_Rates_B[3];
  real_T tmp[9];
  int32_T i;
  if (rtmIsMajorTimeStep((&h_Controllers_M))) {
    /* set solver stop time */
    if (!((&h_Controllers_M)->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&(&h_Controllers_M)->solverInfo, (((&h_Controllers_M)
        ->Timing.clockTickH0 + 1) * (&h_Controllers_M)->Timing.stepSize0 *
        4294967296.0));
    } else {
      rtsiSetSolverStopTime(&(&h_Controllers_M)->solverInfo, (((&h_Controllers_M)
        ->Timing.clockTick0 + 1) * (&h_Controllers_M)->Timing.stepSize0 +
        (&h_Controllers_M)->Timing.clockTickH0 * (&h_Controllers_M)
        ->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep((&h_Controllers_M))) {
    (&h_Controllers_M)->Timing.t[0] = rtsiGetT(&(&h_Controllers_M)->solverInfo);
  }

  /* Saturate: '<S1>/Saturation' incorporates:
   *  Inport: '<Root>/Stick'
   */
  if (h_Controllers_U.Stick[0] > h_Controllers_P.rollMax) {
    Sphi = h_Controllers_P.rollMax;
  } else if (h_Controllers_U.Stick[0] < h_Controllers_P.rollMin) {
    Sphi = h_Controllers_P.rollMin;
  } else {
    Sphi = h_Controllers_U.Stick[0];
  }

  /* Sum: '<S1>/Sum' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   *  Saturate: '<S1>/Saturation'
   */
  rtb_Sum4 = Sphi - h_Controllers_U.IMU_Attitude[0];

  /* Gain: '<S3>/Proportional Gain' */
  rtb_ProportionalGain = h_Controllers_P.KRP * rtb_Sum4;

  /* Gain: '<S3>/Filter Coefficient' incorporates:
   *  Gain: '<S3>/Derivative Gain'
   *  Integrator: '<S3>/Filter'
   *  Sum: '<S3>/SumD'
   */
  h_Controllers_B.FilterCoefficient = (h_Controllers_P.KRD * rtb_Sum4 -
    h_Controllers_X.Filter_CSTATE) * h_Controllers_P.N;

  /* Saturate: '<S1>/Saturation1' incorporates:
   *  Inport: '<Root>/Stick'
   */
  if (h_Controllers_U.Stick[1] > h_Controllers_P.pitchMax) {
    Sphi = h_Controllers_P.pitchMax;
  } else if (h_Controllers_U.Stick[1] < h_Controllers_P.pitchMin) {
    Sphi = h_Controllers_P.pitchMin;
  } else {
    Sphi = h_Controllers_U.Stick[1];
  }

  /* Sum: '<S1>/Sum1' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   *  Saturate: '<S1>/Saturation1'
   */
  rtb_Sum4 = Sphi - h_Controllers_U.IMU_Attitude[1];

  /* Gain: '<S2>/Proportional Gain' */
  rtb_ProportionalGain_g = h_Controllers_P.KPP * rtb_Sum4;

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  Gain: '<S2>/Derivative Gain'
   *  Integrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  h_Controllers_B.FilterCoefficient_c = (h_Controllers_P.KPD * rtb_Sum4 -
    h_Controllers_X.Filter_CSTATE_a) * h_Controllers_P.N;

  /* Gain: '<S1>/Yaw-rate' incorporates:
   *  Inport: '<Root>/Stick'
   */
  h_Controllers_B.Yawrate = h_Controllers_P.KYr * h_Controllers_U.Stick[2];

  /* Sum: '<S1>/Sum2' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   *  Integrator: '<S1>/Integrator'
   */
  rtb_Sum4 = h_Controllers_X.Integrator_CSTATE - h_Controllers_U.IMU_Attitude[2];

  /* Gain: '<S4>/Filter Coefficient' incorporates:
   *  Gain: '<S4>/Derivative Gain'
   *  Integrator: '<S4>/Filter'
   *  Sum: '<S4>/SumD'
   */
  h_Controllers_B.FilterCoefficient_j = (h_Controllers_P.KYD * rtb_Sum4 -
    h_Controllers_X.Filter_CSTATE_g) * h_Controllers_P.N;

  /* MATLAB Function: '<S1>/To body from Earth_rates' incorporates:
   *  Inport: '<Root>/Rates'
   */
  /* MATLAB Function 'Attitude Controller/To body from Earth_rates': '<S8>:1' */
  /* '<S8>:1:3' */
  /* '<S8>:1:4' */
  /* '<S8>:1:6' */
  Sphi = sin(h_Controllers_U.Rates[0]);

  /* '<S8>:1:7' */
  Cphi = cos(h_Controllers_U.Rates[0]);

  /* '<S8>:1:8' */
  /* '<S8>:1:9' */
  Ctheta = cos(h_Controllers_U.Rates[1]);

  /* '<S8>:1:11' */
  /* '<S8>:1:15' */
  tmp[0] = 1.0;
  tmp[3] = 0.0;
  tmp[6] = -sin(h_Controllers_U.Rates[1]);
  tmp[1] = 0.0;
  tmp[4] = Cphi;
  tmp[7] = Sphi * Ctheta;
  tmp[2] = 0.0;
  tmp[5] = -Sphi;
  tmp[8] = Cphi * Ctheta;

  /* SignalConversion: '<S8>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S4>/Proportional Gain'
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Sum: '<S1>/Sum3'
   *  Sum: '<S2>/Sum'
   *  Sum: '<S3>/Sum'
   *  Sum: '<S4>/Sum'
   */
  Ctheta = rtb_ProportionalGain + h_Controllers_B.FilterCoefficient;
  Cphi = rtb_ProportionalGain_g + h_Controllers_B.FilterCoefficient_c;
  Sphi = (h_Controllers_P.KYP * rtb_Sum4 + h_Controllers_B.FilterCoefficient_j)
    + h_Controllers_B.Yawrate;

  /* MATLAB Function: '<S1>/To body from Earth_rates' */
  for (i = 0; i < 3; i++) {
    rtb_Rates_B[i] = tmp[i + 6] * Sphi + (tmp[i + 3] * Cphi + tmp[i] * Ctheta);
  }

  /* Sum: '<S1>/Sum4' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   *  Inport: '<Root>/Rates'
   */
  rtb_Sum4 = (h_Controllers_U.Rates[0] + rtb_Rates_B[0]) -
    h_Controllers_U.IMU_Rates[0];

  /* Gain: '<S5>/Filter Coefficient' incorporates:
   *  Gain: '<S5>/Derivative Gain'
   *  Integrator: '<S5>/Filter'
   *  Sum: '<S5>/SumD'
   */
  h_Controllers_B.FilterCoefficient_d = (h_Controllers_P.Kdp * rtb_Sum4 -
    h_Controllers_X.Filter_CSTATE_o) * h_Controllers_P.N;

  /* Sum: '<S1>/Sum5' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   *  Inport: '<Root>/Rates'
   */
  rtb_ProportionalGain = (h_Controllers_U.Rates[1] + rtb_Rates_B[1]) -
    h_Controllers_U.IMU_Rates[1];

  /* Gain: '<S6>/Filter Coefficient' incorporates:
   *  Gain: '<S6>/Derivative Gain'
   *  Integrator: '<S6>/Filter'
   *  Sum: '<S6>/SumD'
   */
  h_Controllers_B.FilterCoefficient_p = (h_Controllers_P.Kdq *
    rtb_ProportionalGain - h_Controllers_X.Filter_CSTATE_d) * h_Controllers_P.N;

  /* Sum: '<S1>/Sum6' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   *  Inport: '<Root>/Rates'
   */
  rtb_ProportionalGain_g = (h_Controllers_U.Rates[2] + rtb_Rates_B[2]) -
    h_Controllers_U.IMU_Rates[2];

  /* Gain: '<S7>/Filter Coefficient' incorporates:
   *  Gain: '<S7>/Derivative Gain'
   *  Integrator: '<S7>/Filter'
   *  Sum: '<S7>/SumD'
   */
  h_Controllers_B.FilterCoefficient_jq = (h_Controllers_P.Kdr *
    rtb_ProportionalGain_g - h_Controllers_X.Filter_CSTATE_e) *
    h_Controllers_P.N;

  /* Outport: '<Root>/Moments' incorporates:
   *  Gain: '<S5>/Proportional Gain'
   *  Gain: '<S6>/Proportional Gain'
   *  Gain: '<S7>/Proportional Gain'
   *  Integrator: '<S5>/Integrator'
   *  Integrator: '<S6>/Integrator'
   *  Integrator: '<S7>/Integrator'
   *  Sum: '<S5>/Sum'
   *  Sum: '<S6>/Sum'
   *  Sum: '<S7>/Sum'
   */
  h_Controllers_Y.Moments[0] = (h_Controllers_P.Kpp * rtb_Sum4 +
    h_Controllers_X.Integrator_CSTATE_j) + h_Controllers_B.FilterCoefficient_d;
  h_Controllers_Y.Moments[1] = (h_Controllers_P.Kpq * rtb_ProportionalGain +
    h_Controllers_X.Integrator_CSTATE_f) + h_Controllers_B.FilterCoefficient_p;
  h_Controllers_Y.Moments[2] = (h_Controllers_P.Kpr * rtb_ProportionalGain_g +
    h_Controllers_X.Integrator_CSTATE_a) + h_Controllers_B.FilterCoefficient_jq;

  /* Gain: '<S5>/Integral Gain' */
  h_Controllers_B.IntegralGain = h_Controllers_P.Kip * rtb_Sum4;

  /* Gain: '<S6>/Integral Gain' */
  h_Controllers_B.IntegralGain_o = h_Controllers_P.Kiq * rtb_ProportionalGain;

  /* Gain: '<S7>/Integral Gain' */
  h_Controllers_B.IntegralGain_n = h_Controllers_P.Kir * rtb_ProportionalGain_g;
  if (rtmIsMajorTimeStep((&h_Controllers_M))) {
    rt_ertODEUpdateContinuousStates(&(&h_Controllers_M)->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++(&h_Controllers_M)->Timing.clockTick0)) {
      ++(&h_Controllers_M)->Timing.clockTickH0;
    }

    (&h_Controllers_M)->Timing.t[0] = rtsiGetSolverStopTime(&(&h_Controllers_M
      )->solverInfo);

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
      (&h_Controllers_M)->Timing.clockTick1++;
      if (!(&h_Controllers_M)->Timing.clockTick1) {
        (&h_Controllers_M)->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void h_ControllersModelClass::h_Controllers_derivatives()
{
  XDot_h_Controllers_T *_rtXdot;
  _rtXdot = ((XDot_h_Controllers_T *) (&h_Controllers_M)->ModelData.derivs);

  /* Derivatives for Integrator: '<S3>/Filter' */
  _rtXdot->Filter_CSTATE = h_Controllers_B.FilterCoefficient;

  /* Derivatives for Integrator: '<S2>/Filter' */
  _rtXdot->Filter_CSTATE_a = h_Controllers_B.FilterCoefficient_c;

  /* Derivatives for Integrator: '<S1>/Integrator' */
  _rtXdot->Integrator_CSTATE = h_Controllers_B.Yawrate;

  /* Derivatives for Integrator: '<S4>/Filter' */
  _rtXdot->Filter_CSTATE_g = h_Controllers_B.FilterCoefficient_j;

  /* Derivatives for Integrator: '<S5>/Integrator' */
  _rtXdot->Integrator_CSTATE_j = h_Controllers_B.IntegralGain;

  /* Derivatives for Integrator: '<S5>/Filter' */
  _rtXdot->Filter_CSTATE_o = h_Controllers_B.FilterCoefficient_d;

  /* Derivatives for Integrator: '<S6>/Integrator' */
  _rtXdot->Integrator_CSTATE_f = h_Controllers_B.IntegralGain_o;

  /* Derivatives for Integrator: '<S6>/Filter' */
  _rtXdot->Filter_CSTATE_d = h_Controllers_B.FilterCoefficient_p;

  /* Derivatives for Integrator: '<S7>/Integrator' */
  _rtXdot->Integrator_CSTATE_a = h_Controllers_B.IntegralGain_n;

  /* Derivatives for Integrator: '<S7>/Filter' */
  _rtXdot->Filter_CSTATE_e = h_Controllers_B.FilterCoefficient_jq;
}

/* Model initialize function */
void h_ControllersModelClass::initialize()
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)(&h_Controllers_M), 0,
                sizeof(RT_MODEL_h_Controllers_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&(&h_Controllers_M)->solverInfo, &(&h_Controllers_M)
                          ->Timing.simTimeStep);
    rtsiSetTPtr(&(&h_Controllers_M)->solverInfo, &rtmGetTPtr((&h_Controllers_M)));
    rtsiSetStepSizePtr(&(&h_Controllers_M)->solverInfo, &(&h_Controllers_M)
                       ->Timing.stepSize0);
    rtsiSetdXPtr(&(&h_Controllers_M)->solverInfo, &(&h_Controllers_M)
                 ->ModelData.derivs);
    rtsiSetContStatesPtr(&(&h_Controllers_M)->solverInfo, (real_T **)
                         &(&h_Controllers_M)->ModelData.contStates);
    rtsiSetNumContStatesPtr(&(&h_Controllers_M)->solverInfo, &(&h_Controllers_M
      )->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&(&h_Controllers_M)->solverInfo, (&rtmGetErrorStatus((
      &h_Controllers_M))));
    rtsiSetRTModelPtr(&(&h_Controllers_M)->solverInfo, (&h_Controllers_M));
  }

  rtsiSetSimTimeStep(&(&h_Controllers_M)->solverInfo, MAJOR_TIME_STEP);
  (&h_Controllers_M)->ModelData.intgData.y = (&h_Controllers_M)->ModelData.odeY;
  (&h_Controllers_M)->ModelData.intgData.f[0] = (&h_Controllers_M)
    ->ModelData.odeF[0];
  (&h_Controllers_M)->ModelData.intgData.f[1] = (&h_Controllers_M)
    ->ModelData.odeF[1];
  (&h_Controllers_M)->ModelData.contStates = ((X_h_Controllers_T *)
    &h_Controllers_X);
  rtsiSetSolverData(&(&h_Controllers_M)->solverInfo, (void *)&(&h_Controllers_M
                    )->ModelData.intgData);
  rtsiSetSolverName(&(&h_Controllers_M)->solverInfo,"ode2");
  rtmSetTPtr((&h_Controllers_M), &(&h_Controllers_M)->Timing.tArray[0]);
  (&h_Controllers_M)->Timing.stepSize0 = 0.01;

  /* block I/O */
  (void) memset(((void *) &h_Controllers_B), 0,
                sizeof(B_h_Controllers_T));

  /* states (continuous) */
  {
    (void) memset((void *)&h_Controllers_X, 0,
                  sizeof(X_h_Controllers_T));
  }

  /* external inputs */
  (void) memset((void *)&h_Controllers_U, 0,
                sizeof(ExtU_h_Controllers_T));

  /* external outputs */
  (void) memset(&h_Controllers_Y.Moments[0], 0,
                3U*sizeof(real_T));

  /* InitializeConditions for Integrator: '<S3>/Filter' */
  h_Controllers_X.Filter_CSTATE = h_Controllers_P.Filter_IC;

  /* InitializeConditions for Integrator: '<S2>/Filter' */
  h_Controllers_X.Filter_CSTATE_a = h_Controllers_P.Filter_IC_i;

  /* InitializeConditions for Integrator: '<S1>/Integrator' */
  h_Controllers_X.Integrator_CSTATE = h_Controllers_P.Integrator_IC;

  /* InitializeConditions for Integrator: '<S4>/Filter' */
  h_Controllers_X.Filter_CSTATE_g = h_Controllers_P.Filter_IC_o;

  /* InitializeConditions for Integrator: '<S5>/Integrator' */
  h_Controllers_X.Integrator_CSTATE_j = h_Controllers_P.Integrator_IC_c;

  /* InitializeConditions for Integrator: '<S5>/Filter' */
  h_Controllers_X.Filter_CSTATE_o = h_Controllers_P.Filter_IC_a;

  /* InitializeConditions for Integrator: '<S6>/Integrator' */
  h_Controllers_X.Integrator_CSTATE_f = h_Controllers_P.Integrator_IC_l;

  /* InitializeConditions for Integrator: '<S6>/Filter' */
  h_Controllers_X.Filter_CSTATE_d = h_Controllers_P.Filter_IC_l;

  /* InitializeConditions for Integrator: '<S7>/Integrator' */
  h_Controllers_X.Integrator_CSTATE_a = h_Controllers_P.Integrator_IC_o;

  /* InitializeConditions for Integrator: '<S7>/Filter' */
  h_Controllers_X.Filter_CSTATE_e = h_Controllers_P.Filter_IC_c;
}

/* Model terminate function */
void h_ControllersModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
h_ControllersModelClass::h_ControllersModelClass()
{
  static const P_h_Controllers_T h_Controllers_P_temp = {
    0.0,                               /* Variable: KPD
                                        * Referenced by: '<S2>/Derivative Gain'
                                        */
    0.0,                               /* Variable: KPP
                                        * Referenced by: '<S2>/Proportional Gain'
                                        */
    1.0,                               /* Variable: KRD
                                        * Referenced by: '<S3>/Derivative Gain'
                                        */
    10.0,                              /* Variable: KRP
                                        * Referenced by: '<S3>/Proportional Gain'
                                        */
    0.0,                               /* Variable: KYD
                                        * Referenced by: '<S4>/Derivative Gain'
                                        */
    0.0,                               /* Variable: KYP
                                        * Referenced by: '<S4>/Proportional Gain'
                                        */
    0.0,                               /* Variable: KYr
                                        * Referenced by: '<S1>/Yaw-rate'
                                        */
    0.01,                              /* Variable: Kdp
                                        * Referenced by: '<S5>/Derivative Gain'
                                        */
    0.0,                               /* Variable: Kdq
                                        * Referenced by: '<S6>/Derivative Gain'
                                        */
    0.0,                               /* Variable: Kdr
                                        * Referenced by: '<S7>/Derivative Gain'
                                        */
    0.2,                               /* Variable: Kip
                                        * Referenced by: '<S5>/Integral Gain'
                                        */
    0.0,                               /* Variable: Kiq
                                        * Referenced by: '<S6>/Integral Gain'
                                        */
    0.0,                               /* Variable: Kir
                                        * Referenced by: '<S7>/Integral Gain'
                                        */
    0.2,                               /* Variable: Kpp
                                        * Referenced by: '<S5>/Proportional Gain'
                                        */
    0.0,                               /* Variable: Kpq
                                        * Referenced by: '<S6>/Proportional Gain'
                                        */
    0.0,                               /* Variable: Kpr
                                        * Referenced by: '<S7>/Proportional Gain'
                                        */
    100.0,                             /* Variable: N
                                        * Referenced by:
                                        *   '<S2>/Filter Coefficient'
                                        *   '<S3>/Filter Coefficient'
                                        *   '<S4>/Filter Coefficient'
                                        *   '<S5>/Filter Coefficient'
                                        *   '<S6>/Filter Coefficient'
                                        *   '<S7>/Filter Coefficient'
                                        */
    0.52359877559829882,               /* Variable: pitchMax
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    -0.52359877559829882,              /* Variable: pitchMin
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    0.52359877559829882,               /* Variable: rollMax
                                        * Referenced by: '<S1>/Saturation'
                                        */
    -0.52359877559829882,              /* Variable: rollMin
                                        * Referenced by: '<S1>/Saturation'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S3>/Filter'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
    0.0,                               /* Expression: 0
                                        * Referenced by: '<S1>/Integrator'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S4>/Filter'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S5>/Integrator'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S5>/Filter'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S6>/Integrator'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S6>/Filter'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S7>/Integrator'
                                        */
    0.0                                /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S7>/Filter'
                                        */
  };                                   /* Modifiable parameters */

  /* Initialize tunable parameters */
  h_Controllers_P = h_Controllers_P_temp;
}

/* Destructor */
h_ControllersModelClass::~h_ControllersModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_h_Controllers_T * h_ControllersModelClass::getRTM()
{
  return (&h_Controllers_M);
}
