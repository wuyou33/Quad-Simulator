/*
 * h_Controllers.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "h_Controllers".
 *
 * Model version              : 1.49
 * Simulink Coder version : 8.8 (R2015a) 09-Feb-2015
 * C++ source code generated on : Thu Oct 29 13:25:42 2015
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
  int_T nXc = 5;
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

  /* MATLAB Function: '<S1>/To body from Earth_rates' incorporates:
   *  Inport: '<Root>/Rates'
   */
  /* MATLAB Function 'Attitude Controller/To body from Earth_rates': '<S7>:1' */
  /* '<S7>:1:3' */
  /* '<S7>:1:4' */
  /* '<S7>:1:6' */
  Sphi = sin(h_Controllers_U.Rates[0]);

  /* '<S7>:1:7' */
  Cphi = cos(h_Controllers_U.Rates[0]);

  /* '<S7>:1:8' */
  /* '<S7>:1:9' */
  Ctheta = cos(h_Controllers_U.Rates[1]);

  /* '<S7>:1:11' */
  /* '<S7>:1:15' */
  tmp[0] = 1.0;
  tmp[3] = 0.0;
  tmp[6] = -sin(h_Controllers_U.Rates[1]);
  tmp[1] = 0.0;
  tmp[4] = Cphi;
  tmp[7] = Sphi * Ctheta;
  tmp[2] = 0.0;
  tmp[5] = -Sphi;
  tmp[8] = Cphi * Ctheta;

  /* Gain: '<S3>/Proportional Gain' incorporates:
   *  Inport: '<Root>/Stick'
   *  Saturate: '<S1>/Saturation'
   */
  if (h_Controllers_U.Stick[0] > h_Controllers_P.Saturation_UpperSat) {
    Sphi = h_Controllers_P.Saturation_UpperSat;
  } else if (h_Controllers_U.Stick[0] < h_Controllers_P.Saturation_LowerSat) {
    Sphi = h_Controllers_P.Saturation_LowerSat;
  } else {
    Sphi = h_Controllers_U.Stick[0];
  }

  /* SignalConversion: '<S7>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S1>/Yaw-rate1'
   *  Gain: '<S3>/Proportional Gain'
   *  Inport: '<Root>/IMU_Attitude'
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Saturate: '<S1>/Saturation'
   *  Sum: '<S1>/Sum'
   */
  Cphi = (h_Controllers_P.rollMax * Sphi - h_Controllers_U.IMU_Attitude[0]) *
    h_Controllers_P.KRP;

  /* Gain: '<S2>/Proportional Gain' incorporates:
   *  Inport: '<Root>/Stick'
   *  Saturate: '<S1>/Saturation1'
   */
  if (h_Controllers_U.Stick[1] > h_Controllers_P.Saturation1_UpperSat) {
    Sphi = h_Controllers_P.Saturation1_UpperSat;
  } else if (h_Controllers_U.Stick[1] < h_Controllers_P.Saturation1_LowerSat) {
    Sphi = h_Controllers_P.Saturation1_LowerSat;
  } else {
    Sphi = h_Controllers_U.Stick[1];
  }

  /* SignalConversion: '<S7>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S1>/Yaw-rate2'
   *  Gain: '<S2>/Proportional Gain'
   *  Inport: '<Root>/IMU_Attitude'
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Saturate: '<S1>/Saturation1'
   *  Sum: '<S1>/Sum1'
   */
  Ctheta = (h_Controllers_P.pitchMax * Sphi - h_Controllers_U.IMU_Attitude[1]) *
    h_Controllers_P.KPP;

  /* Gain: '<S1>/Yaw-rate' incorporates:
   *  Inport: '<Root>/Stick'
   *  Saturate: '<S1>/Saturation2'
   */
  if (h_Controllers_U.Stick[2] > h_Controllers_P.Saturation2_UpperSat) {
    Sphi = h_Controllers_P.Saturation2_UpperSat;
  } else if (h_Controllers_U.Stick[2] < h_Controllers_P.Saturation2_LowerSat) {
    Sphi = h_Controllers_P.Saturation2_LowerSat;
  } else {
    Sphi = h_Controllers_U.Stick[2];
  }

  /* SignalConversion: '<S7>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S1>/Yaw-rate'
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Saturate: '<S1>/Saturation2'
   */
  Sphi *= h_Controllers_P.yawRateMax;

  /* MATLAB Function: '<S1>/To body from Earth_rates' */
  for (i = 0; i < 3; i++) {
    rtb_Rates_B[i] = tmp[i + 6] * Sphi + (tmp[i + 3] * Ctheta + tmp[i] * Cphi);
  }

  /* Sum: '<S1>/Sum4' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   *  Inport: '<Root>/Rates'
   */
  Sphi = (h_Controllers_U.Rates[0] + rtb_Rates_B[0]) -
    h_Controllers_U.IMU_Rates[0];

  /* Gain: '<S4>/Filter Coefficient' incorporates:
   *  Gain: '<S4>/Derivative Gain'
   *  Integrator: '<S4>/Filter'
   *  Sum: '<S4>/SumD'
   */
  h_Controllers_B.FilterCoefficient = (h_Controllers_P.Kdp * Sphi -
    h_Controllers_X.Filter_CSTATE) * h_Controllers_P.N;

  /* Sum: '<S1>/Sum5' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   *  Inport: '<Root>/Rates'
   */
  Cphi = (h_Controllers_U.Rates[1] + rtb_Rates_B[1]) -
    h_Controllers_U.IMU_Rates[1];

  /* Gain: '<S5>/Filter Coefficient' incorporates:
   *  Gain: '<S5>/Derivative Gain'
   *  Integrator: '<S5>/Filter'
   *  Sum: '<S5>/SumD'
   */
  h_Controllers_B.FilterCoefficient_p = (h_Controllers_P.Kdq * Cphi -
    h_Controllers_X.Filter_CSTATE_d) * h_Controllers_P.N;

  /* Sum: '<S1>/Sum6' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   *  Inport: '<Root>/Rates'
   */
  Ctheta = (h_Controllers_U.Rates[2] + rtb_Rates_B[2]) -
    h_Controllers_U.IMU_Rates[2];

  /* Outport: '<Root>/Moments' incorporates:
   *  Gain: '<S4>/Proportional Gain'
   *  Gain: '<S5>/Proportional Gain'
   *  Gain: '<S6>/Proportional Gain'
   *  Integrator: '<S4>/Integrator'
   *  Integrator: '<S5>/Integrator'
   *  Integrator: '<S6>/Integrator'
   *  Sum: '<S4>/Sum'
   *  Sum: '<S5>/Sum'
   *  Sum: '<S6>/Sum'
   */
  h_Controllers_Y.Moments[0] = (h_Controllers_P.Kpp * Sphi +
    h_Controllers_X.Integrator_CSTATE) + h_Controllers_B.FilterCoefficient;
  h_Controllers_Y.Moments[1] = (h_Controllers_P.Kpq * Cphi +
    h_Controllers_X.Integrator_CSTATE_f) + h_Controllers_B.FilterCoefficient_p;
  h_Controllers_Y.Moments[2] = h_Controllers_P.Kpr * Ctheta +
    h_Controllers_X.Integrator_CSTATE_a;

  /* Gain: '<S4>/Integral Gain' */
  h_Controllers_B.IntegralGain = h_Controllers_P.Kip * Sphi;

  /* Gain: '<S5>/Integral Gain' */
  h_Controllers_B.IntegralGain_o = h_Controllers_P.Kiq * Cphi;

  /* Gain: '<S6>/Integral Gain' */
  h_Controllers_B.IntegralGain_n = h_Controllers_P.Kir * Ctheta;
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

  /* Derivatives for Integrator: '<S4>/Integrator' */
  _rtXdot->Integrator_CSTATE = h_Controllers_B.IntegralGain;

  /* Derivatives for Integrator: '<S4>/Filter' */
  _rtXdot->Filter_CSTATE = h_Controllers_B.FilterCoefficient;

  /* Derivatives for Integrator: '<S5>/Integrator' */
  _rtXdot->Integrator_CSTATE_f = h_Controllers_B.IntegralGain_o;

  /* Derivatives for Integrator: '<S5>/Filter' */
  _rtXdot->Filter_CSTATE_d = h_Controllers_B.FilterCoefficient_p;

  /* Derivatives for Integrator: '<S6>/Integrator' */
  _rtXdot->Integrator_CSTATE_a = h_Controllers_B.IntegralGain_n;
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

  /* InitializeConditions for Integrator: '<S4>/Integrator' */
  h_Controllers_X.Integrator_CSTATE = h_Controllers_P.Integrator_IC;

  /* InitializeConditions for Integrator: '<S4>/Filter' */
  h_Controllers_X.Filter_CSTATE = h_Controllers_P.Filter_IC;

  /* InitializeConditions for Integrator: '<S5>/Integrator' */
  h_Controllers_X.Integrator_CSTATE_f = h_Controllers_P.Integrator_IC_l;

  /* InitializeConditions for Integrator: '<S5>/Filter' */
  h_Controllers_X.Filter_CSTATE_d = h_Controllers_P.Filter_IC_l;

  /* InitializeConditions for Integrator: '<S6>/Integrator' */
  h_Controllers_X.Integrator_CSTATE_a = h_Controllers_P.Integrator_IC_o;
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
    0.0,                               /* Variable: KPP
                                        * Referenced by: '<S2>/Proportional Gain'
                                        */
    0.0,                               /* Variable: KRP
                                        * Referenced by: '<S3>/Proportional Gain'
                                        */
    0.0,                               /* Variable: Kdp
                                        * Referenced by: '<S4>/Derivative Gain'
                                        */
    0.0,                               /* Variable: Kdq
                                        * Referenced by: '<S5>/Derivative Gain'
                                        */
    0.0,                               /* Variable: Kip
                                        * Referenced by: '<S4>/Integral Gain'
                                        */
    0.0,                               /* Variable: Kiq
                                        * Referenced by: '<S5>/Integral Gain'
                                        */
    0.1,                               /* Variable: Kir
                                        * Referenced by: '<S6>/Integral Gain'
                                        */
    0.0,                               /* Variable: Kpp
                                        * Referenced by: '<S4>/Proportional Gain'
                                        */
    0.0,                               /* Variable: Kpq
                                        * Referenced by: '<S5>/Proportional Gain'
                                        */
    0.05,                              /* Variable: Kpr
                                        * Referenced by: '<S6>/Proportional Gain'
                                        */
    100.0,                             /* Variable: N
                                        * Referenced by:
                                        *   '<S4>/Filter Coefficient'
                                        *   '<S5>/Filter Coefficient'
                                        */
    0.52359877559829882,               /* Variable: pitchMax
                                        * Referenced by: '<S1>/Yaw-rate2'
                                        */
    0.52359877559829882,               /* Variable: rollMax
                                        * Referenced by: '<S1>/Yaw-rate1'
                                        */
    3.0,                               /* Variable: yawRateMax
                                        * Referenced by: '<S1>/Yaw-rate'
                                        */
    1.0,                               /* Expression: 1
                                        * Referenced by: '<S1>/Saturation'
                                        */
    -1.0,                              /* Expression: -1
                                        * Referenced by: '<S1>/Saturation'
                                        */
    1.0,                               /* Expression: 1
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    -1.0,                              /* Expression: -1
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    1.0,                               /* Expression: 1
                                        * Referenced by: '<S1>/Saturation2'
                                        */
    -1.0,                              /* Expression: -1
                                        * Referenced by: '<S1>/Saturation2'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S4>/Integrator'
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
    0.0                                /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S6>/Integrator'
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
