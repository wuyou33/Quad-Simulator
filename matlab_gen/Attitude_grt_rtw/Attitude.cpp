/*
 * Attitude.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Attitude".
 *
 * Model version              : 1.88
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Thu May 19 10:17:03 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "Attitude.h"
#include "Attitude_private.h"

/*
 * This function updates continuous states using the ODE2 fixed-step
 * solver algorithm
 */
void AttitudeModelClass::rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
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
  int_T nXc = 9;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Attitude_derivatives();

  /* f1 = f(t + h, y + h*f0) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (h*f0[i]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f1);
  this->step();
  Attitude_derivatives();

  /* tnew = t + h
     ynew = y + (h/2)*(f0 + f1) */
  temp = 0.5*h;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + f1[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void AttitudeModelClass::step()
{
  real_T Sphi;
  real_T Cphi;
  real_T Ctheta;
  real_T rtb_Sum4;
  real_T rtb_ProportionalGain;
  real_T rtb_ProportionalGain_h;
  real_T rtb_Rates_B[3];
  real_T rtb_Sum_k;
  real_T rtb_Saturate_l;
  real_T rtb_Switch;
  real_T tmp[9];
  int32_T i;
  if (rtmIsMajorTimeStep((&Attitude_M))) {
    /* set solver stop time */
    if (!((&Attitude_M)->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&(&Attitude_M)->solverInfo, (((&Attitude_M)
        ->Timing.clockTickH0 + 1) * (&Attitude_M)->Timing.stepSize0 *
        4294967296.0));
    } else {
      rtsiSetSolverStopTime(&(&Attitude_M)->solverInfo, (((&Attitude_M)
        ->Timing.clockTick0 + 1) * (&Attitude_M)->Timing.stepSize0 +
        (&Attitude_M)->Timing.clockTickH0 * (&Attitude_M)->Timing.stepSize0 *
        4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep((&Attitude_M))) {
    (&Attitude_M)->Timing.t[0] = rtsiGetT(&(&Attitude_M)->solverInfo);
  }

  /* Saturate: '<S1>/Saturation' incorporates:
   *  Inport: '<Root>/Stick'
   */
  if (Attitude_U.Stick[0] > Attitude_P.Saturation_UpperSat) {
    rtb_Sum4 = Attitude_P.Saturation_UpperSat;
  } else if (Attitude_U.Stick[0] < Attitude_P.Saturation_LowerSat) {
    rtb_Sum4 = Attitude_P.Saturation_LowerSat;
  } else {
    rtb_Sum4 = Attitude_U.Stick[0];
  }

  /* Sum: '<S1>/Sum' incorporates:
   *  Gain: '<S1>/Yaw-rate1'
   *  Inport: '<Root>/IMU_Attitude'
   *  Saturate: '<S1>/Saturation'
   */
  rtb_Sum4 = Attitude_P.rollMax * rtb_Sum4 - Attitude_U.IMU_Attitude[0];

  /* Gain: '<S3>/Proportional Gain' */
  rtb_ProportionalGain = Attitude_P.KRP * rtb_Sum4;

  /* Gain: '<S3>/Filter Coefficient' incorporates:
   *  Gain: '<S3>/Derivative Gain'
   *  Integrator: '<S3>/Filter'
   *  Sum: '<S3>/SumD'
   */
  Attitude_B.FilterCoefficient = (Attitude_P.KRD * rtb_Sum4 -
    Attitude_X.Filter_CSTATE) * Attitude_P.N;

  /* Saturate: '<S1>/Saturation1' incorporates:
   *  Inport: '<Root>/Stick'
   */
  if (Attitude_U.Stick[1] > Attitude_P.Saturation1_UpperSat) {
    rtb_Sum4 = Attitude_P.Saturation1_UpperSat;
  } else if (Attitude_U.Stick[1] < Attitude_P.Saturation1_LowerSat) {
    rtb_Sum4 = Attitude_P.Saturation1_LowerSat;
  } else {
    rtb_Sum4 = Attitude_U.Stick[1];
  }

  /* Sum: '<S1>/Sum1' incorporates:
   *  Gain: '<S1>/Yaw-rate2'
   *  Inport: '<Root>/IMU_Attitude'
   *  Saturate: '<S1>/Saturation1'
   */
  rtb_Sum4 = Attitude_P.pitchMax * rtb_Sum4 - Attitude_U.IMU_Attitude[1];

  /* Gain: '<S2>/Proportional Gain' */
  rtb_ProportionalGain_h = Attitude_P.KPP * rtb_Sum4;

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  Gain: '<S2>/Derivative Gain'
   *  Integrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  Attitude_B.FilterCoefficient_e = (Attitude_P.KPD * rtb_Sum4 -
    Attitude_X.Filter_CSTATE_m) * Attitude_P.N;

  /* Sum: '<S1>/Sum2' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   *  Inport: '<Root>/Stick'
   */
  rtb_Sum4 = Attitude_U.Stick[3] - Attitude_U.IMU_Attitude[2];

  /* Gain: '<S4>/Filter Coefficient' incorporates:
   *  Gain: '<S4>/Derivative Gain'
   *  Integrator: '<S4>/Filter'
   *  Sum: '<S4>/SumD'
   */
  Attitude_B.FilterCoefficient_d = (Attitude_P.KYD * rtb_Sum4 -
    Attitude_X.Filter_CSTATE_mi) * Attitude_P.N;

  /* Switch: '<S1>/Switch' incorporates:
   *  Gain: '<S1>/Yaw-rate3'
   *  Gain: '<S4>/Proportional Gain'
   *  Inport: '<Root>/Selector'
   *  Inport: '<Root>/Stick'
   *  Saturate: '<S1>/Saturation2'
   *  Sum: '<S4>/Sum'
   */
  if (Attitude_U.Selector >= Attitude_P.Switch_Threshold) {
    rtb_Switch = Attitude_P.KYP * rtb_Sum4 + Attitude_B.FilterCoefficient_d;
  } else {
    if (Attitude_U.Stick[2] > Attitude_P.Saturation2_UpperSat) {
      /* Saturate: '<S1>/Saturation2' */
      rtb_Sum4 = Attitude_P.Saturation2_UpperSat;
    } else if (Attitude_U.Stick[2] < Attitude_P.Saturation2_LowerSat) {
      /* Saturate: '<S1>/Saturation2' */
      rtb_Sum4 = Attitude_P.Saturation2_LowerSat;
    } else {
      /* Saturate: '<S1>/Saturation2' incorporates:
       *  Inport: '<Root>/Stick'
       */
      rtb_Sum4 = Attitude_U.Stick[2];
    }

    rtb_Switch = Attitude_P.yawRateMax * rtb_Sum4;
  }

  /* End of Switch: '<S1>/Switch' */

  /* MATLAB Function: '<S1>/To body from Earth_rates' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   */
  /* MATLAB Function 'Attitude Controller/To body from Earth_rates': '<S8>:1' */
  /* '<S8>:1:3' */
  /* '<S8>:1:4' */
  /* '<S8>:1:6' */
  Sphi = sin(Attitude_U.IMU_Attitude[0]);

  /* '<S8>:1:7' */
  Cphi = cos(Attitude_U.IMU_Attitude[0]);

  /* '<S8>:1:8' */
  /* '<S8>:1:9' */
  Ctheta = cos(Attitude_U.IMU_Attitude[1]);

  /* '<S8>:1:11' */
  /* '<S8>:1:15' */
  tmp[0] = 1.0;
  tmp[3] = 0.0;
  tmp[6] = -sin(Attitude_U.IMU_Attitude[1]);
  tmp[1] = 0.0;
  tmp[4] = Cphi;
  tmp[7] = Sphi * Ctheta;
  tmp[2] = 0.0;
  tmp[5] = -Sphi;
  tmp[8] = Cphi * Ctheta;

  /* SignalConversion: '<S8>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Sum: '<S2>/Sum'
   *  Sum: '<S3>/Sum'
   */
  Sphi = rtb_ProportionalGain + Attitude_B.FilterCoefficient;
  rtb_Sum4 = rtb_ProportionalGain_h + Attitude_B.FilterCoefficient_e;

  /* MATLAB Function: '<S1>/To body from Earth_rates' incorporates:
   *  SignalConversion: '<S8>/TmpSignal ConversionAt SFunction Inport2'
   */
  for (i = 0; i < 3; i++) {
    rtb_Rates_B[i] = tmp[i + 6] * rtb_Switch + (tmp[i + 3] * rtb_Sum4 + tmp[i] *
      Sphi);
  }

  /* Sum: '<S1>/Sum4' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   */
  rtb_Sum4 = rtb_Rates_B[0] - Attitude_U.IMU_Rates[0];

  /* Gain: '<S5>/Filter Coefficient' incorporates:
   *  Gain: '<S5>/Derivative Gain'
   *  Integrator: '<S5>/Filter'
   *  Sum: '<S5>/SumD'
   */
  Attitude_B.FilterCoefficient_o = (Attitude_P.Kdp * rtb_Sum4 -
    Attitude_X.Filter_CSTATE_k) * Attitude_P.N;

  /* Sum: '<S5>/Sum' incorporates:
   *  Gain: '<S5>/Proportional Gain'
   *  Integrator: '<S5>/Integrator'
   */
  rtb_Switch = (Attitude_P.Kpp * rtb_Sum4 + Attitude_X.Integrator_CSTATE) +
    Attitude_B.FilterCoefficient_o;

  /* Saturate: '<S5>/Saturate' */
  if (rtb_Switch > Attitude_P.satp) {
    Sphi = Attitude_P.satp;
  } else if (rtb_Switch < -Attitude_P.satp) {
    Sphi = -Attitude_P.satp;
  } else {
    Sphi = rtb_Switch;
  }

  /* End of Saturate: '<S5>/Saturate' */

  /* Sum: '<S1>/Sum5' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   */
  Cphi = rtb_Rates_B[1] - Attitude_U.IMU_Rates[1];

  /* Gain: '<S6>/Filter Coefficient' incorporates:
   *  Gain: '<S6>/Derivative Gain'
   *  Integrator: '<S6>/Filter'
   *  Sum: '<S6>/SumD'
   */
  Attitude_B.FilterCoefficient_b = (Attitude_P.Kdq * Cphi -
    Attitude_X.Filter_CSTATE_e) * Attitude_P.N;

  /* Sum: '<S6>/Sum' incorporates:
   *  Gain: '<S6>/Proportional Gain'
   *  Integrator: '<S6>/Integrator'
   */
  Ctheta = (Attitude_P.Kpq * Cphi + Attitude_X.Integrator_CSTATE_f) +
    Attitude_B.FilterCoefficient_b;

  /* Saturate: '<S6>/Saturate' */
  if (Ctheta > Attitude_P.satq) {
    rtb_ProportionalGain = Attitude_P.satq;
  } else if (Ctheta < -Attitude_P.satq) {
    rtb_ProportionalGain = -Attitude_P.satq;
  } else {
    rtb_ProportionalGain = Ctheta;
  }

  /* End of Saturate: '<S6>/Saturate' */

  /* Sum: '<S1>/Sum6' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   */
  rtb_ProportionalGain_h = rtb_Rates_B[2] - Attitude_U.IMU_Rates[2];

  /* Gain: '<S7>/Filter Coefficient' incorporates:
   *  Gain: '<S7>/Derivative Gain'
   *  Integrator: '<S7>/Filter'
   *  Sum: '<S7>/SumD'
   */
  Attitude_B.FilterCoefficient_oo = (Attitude_P.Kdr * rtb_ProportionalGain_h -
    Attitude_X.Filter_CSTATE_g) * Attitude_P.N;

  /* Sum: '<S7>/Sum' incorporates:
   *  Gain: '<S7>/Proportional Gain'
   *  Integrator: '<S7>/Integrator'
   */
  rtb_Sum_k = (Attitude_P.Kpr * rtb_ProportionalGain_h +
               Attitude_X.Integrator_CSTATE_h) + Attitude_B.FilterCoefficient_oo;

  /* Saturate: '<S7>/Saturate' */
  if (rtb_Sum_k > Attitude_P.satr) {
    rtb_Saturate_l = Attitude_P.satr;
  } else if (rtb_Sum_k < -Attitude_P.satr) {
    rtb_Saturate_l = -Attitude_P.satr;
  } else {
    rtb_Saturate_l = rtb_Sum_k;
  }

  /* End of Saturate: '<S7>/Saturate' */

  /* Outport: '<Root>/Moments' */
  Attitude_Y.Moments[0] = Sphi;
  Attitude_Y.Moments[1] = rtb_ProportionalGain;
  Attitude_Y.Moments[2] = rtb_Saturate_l;

  /* Sum: '<S5>/SumI1' incorporates:
   *  Gain: '<S5>/Integral Gain'
   *  Gain: '<S5>/Kb'
   *  Sum: '<S5>/SumI2'
   */
  Attitude_B.SumI1 = (Sphi - rtb_Switch) * Attitude_P.Kbp + Attitude_P.Kip *
    rtb_Sum4;

  /* Sum: '<S6>/SumI1' incorporates:
   *  Gain: '<S6>/Integral Gain'
   *  Gain: '<S6>/Kb'
   *  Sum: '<S6>/SumI2'
   */
  Attitude_B.SumI1_e = (rtb_ProportionalGain - Ctheta) * Attitude_P.Kbq +
    Attitude_P.Kiq * Cphi;

  /* Sum: '<S7>/SumI1' incorporates:
   *  Gain: '<S7>/Integral Gain'
   *  Gain: '<S7>/Kb'
   *  Sum: '<S7>/SumI2'
   */
  Attitude_B.SumI1_k = (rtb_Saturate_l - rtb_Sum_k) * Attitude_P.Kbr +
    Attitude_P.Kir * rtb_ProportionalGain_h;
  if (rtmIsMajorTimeStep((&Attitude_M))) {
    rt_ertODEUpdateContinuousStates(&(&Attitude_M)->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++(&Attitude_M)->Timing.clockTick0)) {
      ++(&Attitude_M)->Timing.clockTickH0;
    }

    (&Attitude_M)->Timing.t[0] = rtsiGetSolverStopTime(&(&Attitude_M)
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
      (&Attitude_M)->Timing.clockTick1++;
      if (!(&Attitude_M)->Timing.clockTick1) {
        (&Attitude_M)->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void AttitudeModelClass::Attitude_derivatives()
{
  XDot_Attitude_T *_rtXdot;
  _rtXdot = ((XDot_Attitude_T *) (&Attitude_M)->ModelData.derivs);

  /* Derivatives for Integrator: '<S3>/Filter' */
  _rtXdot->Filter_CSTATE = Attitude_B.FilterCoefficient;

  /* Derivatives for Integrator: '<S2>/Filter' */
  _rtXdot->Filter_CSTATE_m = Attitude_B.FilterCoefficient_e;

  /* Derivatives for Integrator: '<S4>/Filter' */
  _rtXdot->Filter_CSTATE_mi = Attitude_B.FilterCoefficient_d;

  /* Derivatives for Integrator: '<S5>/Integrator' */
  _rtXdot->Integrator_CSTATE = Attitude_B.SumI1;

  /* Derivatives for Integrator: '<S5>/Filter' */
  _rtXdot->Filter_CSTATE_k = Attitude_B.FilterCoefficient_o;

  /* Derivatives for Integrator: '<S6>/Integrator' */
  _rtXdot->Integrator_CSTATE_f = Attitude_B.SumI1_e;

  /* Derivatives for Integrator: '<S6>/Filter' */
  _rtXdot->Filter_CSTATE_e = Attitude_B.FilterCoefficient_b;

  /* Derivatives for Integrator: '<S7>/Integrator' */
  _rtXdot->Integrator_CSTATE_h = Attitude_B.SumI1_k;

  /* Derivatives for Integrator: '<S7>/Filter' */
  _rtXdot->Filter_CSTATE_g = Attitude_B.FilterCoefficient_oo;
}

/* Model initialize function */
void AttitudeModelClass::initialize()
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)(&Attitude_M), 0,
                sizeof(RT_MODEL_Attitude_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&(&Attitude_M)->solverInfo, &(&Attitude_M)
                          ->Timing.simTimeStep);
    rtsiSetTPtr(&(&Attitude_M)->solverInfo, &rtmGetTPtr((&Attitude_M)));
    rtsiSetStepSizePtr(&(&Attitude_M)->solverInfo, &(&Attitude_M)
                       ->Timing.stepSize0);
    rtsiSetdXPtr(&(&Attitude_M)->solverInfo, &(&Attitude_M)->ModelData.derivs);
    rtsiSetContStatesPtr(&(&Attitude_M)->solverInfo, (real_T **) &(&Attitude_M
                         )->ModelData.contStates);
    rtsiSetNumContStatesPtr(&(&Attitude_M)->solverInfo, &(&Attitude_M)
      ->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&(&Attitude_M)->solverInfo, (&rtmGetErrorStatus
      ((&Attitude_M))));
    rtsiSetRTModelPtr(&(&Attitude_M)->solverInfo, (&Attitude_M));
  }

  rtsiSetSimTimeStep(&(&Attitude_M)->solverInfo, MAJOR_TIME_STEP);
  (&Attitude_M)->ModelData.intgData.y = (&Attitude_M)->ModelData.odeY;
  (&Attitude_M)->ModelData.intgData.f[0] = (&Attitude_M)->ModelData.odeF[0];
  (&Attitude_M)->ModelData.intgData.f[1] = (&Attitude_M)->ModelData.odeF[1];
  (&Attitude_M)->ModelData.contStates = ((X_Attitude_T *) &Attitude_X);
  rtsiSetSolverData(&(&Attitude_M)->solverInfo, (void *)&(&Attitude_M)
                    ->ModelData.intgData);
  rtsiSetSolverName(&(&Attitude_M)->solverInfo,"ode2");
  rtmSetTPtr((&Attitude_M), &(&Attitude_M)->Timing.tArray[0]);
  (&Attitude_M)->Timing.stepSize0 = 0.01;

  /* block I/O */
  (void) memset(((void *) &Attitude_B), 0,
                sizeof(B_Attitude_T));

  /* states (continuous) */
  {
    (void) memset((void *)&Attitude_X, 0,
                  sizeof(X_Attitude_T));
  }

  /* external inputs */
  (void) memset((void *)&Attitude_U, 0,
                sizeof(ExtU_Attitude_T));

  /* external outputs */
  (void) memset(&Attitude_Y.Moments[0], 0,
                3U*sizeof(real_T));

  /* InitializeConditions for Integrator: '<S3>/Filter' */
  Attitude_X.Filter_CSTATE = Attitude_P.Filter_IC;

  /* InitializeConditions for Integrator: '<S2>/Filter' */
  Attitude_X.Filter_CSTATE_m = Attitude_P.Filter_IC_f;

  /* InitializeConditions for Integrator: '<S4>/Filter' */
  Attitude_X.Filter_CSTATE_mi = Attitude_P.Filter_IC_e;

  /* InitializeConditions for Integrator: '<S5>/Integrator' */
  Attitude_X.Integrator_CSTATE = Attitude_P.Integrator_IC;

  /* InitializeConditions for Integrator: '<S5>/Filter' */
  Attitude_X.Filter_CSTATE_k = Attitude_P.Filter_IC_c;

  /* InitializeConditions for Integrator: '<S6>/Integrator' */
  Attitude_X.Integrator_CSTATE_f = Attitude_P.Integrator_IC_l;

  /* InitializeConditions for Integrator: '<S6>/Filter' */
  Attitude_X.Filter_CSTATE_e = Attitude_P.Filter_IC_fv;

  /* InitializeConditions for Integrator: '<S7>/Integrator' */
  Attitude_X.Integrator_CSTATE_h = Attitude_P.Integrator_IC_k;

  /* InitializeConditions for Integrator: '<S7>/Filter' */
  Attitude_X.Filter_CSTATE_g = Attitude_P.Filter_IC_a;
}

/* Model terminate function */
void AttitudeModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
AttitudeModelClass::AttitudeModelClass()
{
  static const P_Attitude_T Attitude_P_temp = {
    0.00512,                           /* Variable: KPD
                                        * Referenced by: '<S2>/Derivative Gain'
                                        */
    1.61,                              /* Variable: KPP
                                        * Referenced by: '<S2>/Proportional Gain'
                                        */
    0.00512,                           /* Variable: KRD
                                        * Referenced by: '<S3>/Derivative Gain'
                                        */
    1.61,                              /* Variable: KRP
                                        * Referenced by: '<S3>/Proportional Gain'
                                        */
    0.216,                             /* Variable: KYD
                                        * Referenced by: '<S4>/Derivative Gain'
                                        */
    1.41,                              /* Variable: KYP
                                        * Referenced by: '<S4>/Proportional Gain'
                                        */
    0.40514779629427244,               /* Variable: Kbp
                                        * Referenced by: '<S5>/Kb'
                                        */
    0.40514779629427244,               /* Variable: Kbq
                                        * Referenced by: '<S6>/Kb'
                                        */
    0.38746423667787738,               /* Variable: Kbr
                                        * Referenced by: '<S7>/Kb'
                                        */
    0.0499,                            /* Variable: Kdp
                                        * Referenced by: '<S5>/Derivative Gain'
                                        */
    0.0499,                            /* Variable: Kdq
                                        * Referenced by: '<S6>/Derivative Gain'
                                        */
    0.00584,                           /* Variable: Kdr
                                        * Referenced by: '<S7>/Derivative Gain'
                                        */
    0.304,                             /* Variable: Kip
                                        * Referenced by: '<S5>/Integral Gain'
                                        */
    0.304,                             /* Variable: Kiq
                                        * Referenced by: '<S6>/Integral Gain'
                                        */
    0.0389,                            /* Variable: Kir
                                        * Referenced by: '<S7>/Integral Gain'
                                        */
    0.298,                             /* Variable: Kpp
                                        * Referenced by: '<S5>/Proportional Gain'
                                        */
    0.298,                             /* Variable: Kpq
                                        * Referenced by: '<S6>/Proportional Gain'
                                        */
    0.135,                             /* Variable: Kpr
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
                                        * Referenced by: '<S1>/Yaw-rate2'
                                        */
    0.52359877559829882,               /* Variable: rollMax
                                        * Referenced by: '<S1>/Yaw-rate1'
                                        */
    1.5,                               /* Variable: satp
                                        * Referenced by: '<S5>/Saturate'
                                        */
    1.5,                               /* Variable: satq
                                        * Referenced by: '<S6>/Saturate'
                                        */
    1.0,                               /* Variable: satr
                                        * Referenced by: '<S7>/Saturate'
                                        */
    1.5707963267948966,                /* Variable: yawRateMax
                                        * Referenced by: '<S1>/Yaw-rate3'
                                        */
    1.0,                               /* Expression: 1
                                        * Referenced by: '<S1>/Saturation2'
                                        */
    -1.0,                              /* Expression: -1
                                        * Referenced by: '<S1>/Saturation2'
                                        */
    1.0,                               /* Expression: 1
                                        * Referenced by: '<S1>/Saturation'
                                        */
    -1.0,                              /* Expression: -1
                                        * Referenced by: '<S1>/Saturation'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S3>/Filter'
                                        */
    1.0,                               /* Expression: 1
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    -1.0,                              /* Expression: -1
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
    0.0,                               /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S4>/Filter'
                                        */
    3.0,                               /* Expression: 3
                                        * Referenced by: '<S1>/Switch'
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
  Attitude_P = Attitude_P_temp;
}

/* Destructor */
AttitudeModelClass::~AttitudeModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_Attitude_T * AttitudeModelClass::getRTM()
{
  return (&Attitude_M);
}
