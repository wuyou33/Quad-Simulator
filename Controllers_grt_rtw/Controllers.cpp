/*
 * Controllers.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Controllers".
 *
 * Model version              : 1.83
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Sat Apr 02 10:37:09 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "Controllers.h"
#include "Controllers_private.h"

/*
 * This function updates continuous states using the ODE2 fixed-step
 * solver algorithm
 */
void ControllersModelClass::rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
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
  int_T nXc = 8;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Controllers_derivatives();

  /* f1 = f(t + h, y + h*f0) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (h*f0[i]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f1);
  this->step();
  Controllers_derivatives();

  /* tnew = t + h
     ynew = y + (h/2)*(f0 + f1) */
  temp = 0.5*h;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + f1[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void ControllersModelClass::step()
{
  real_T Sphi;
  real_T Cphi;
  real_T Ctheta;
  real_T rtb_Sum4;
  real_T rtb_ProportionalGain;
  real_T rtb_Rates_B[3];
  real_T rtb_Saturate_p;
  real_T rtb_Sum6;
  real_T rtb_Sum_ou;
  real_T rtb_Saturate_e;
  real_T tmp[9];
  int32_T i;
  if (rtmIsMajorTimeStep((&Controllers_M))) {
    /* set solver stop time */
    if (!((&Controllers_M)->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&(&Controllers_M)->solverInfo, (((&Controllers_M)
        ->Timing.clockTickH0 + 1) * (&Controllers_M)->Timing.stepSize0 *
        4294967296.0));
    } else {
      rtsiSetSolverStopTime(&(&Controllers_M)->solverInfo, (((&Controllers_M)
        ->Timing.clockTick0 + 1) * (&Controllers_M)->Timing.stepSize0 +
        (&Controllers_M)->Timing.clockTickH0 * (&Controllers_M)
        ->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep((&Controllers_M))) {
    (&Controllers_M)->Timing.t[0] = rtsiGetT(&(&Controllers_M)->solverInfo);
  }

  /* Saturate: '<S1>/Saturation' incorporates:
   *  Inport: '<Root>/Stick'
   */
  if (Controllers_U.Stick[0] > Controllers_P.Saturation_UpperSat) {
    Sphi = Controllers_P.Saturation_UpperSat;
  } else if (Controllers_U.Stick[0] < Controllers_P.Saturation_LowerSat) {
    Sphi = Controllers_P.Saturation_LowerSat;
  } else {
    Sphi = Controllers_U.Stick[0];
  }

  /* Sum: '<S1>/Sum' incorporates:
   *  Gain: '<S1>/Yaw-rate1'
   *  Inport: '<Root>/IMU_Attitude'
   *  Saturate: '<S1>/Saturation'
   */
  rtb_Sum4 = Controllers_P.rollMax * Sphi - Controllers_U.IMU_Attitude[0];

  /* Gain: '<S3>/Proportional Gain' */
  rtb_ProportionalGain = Controllers_P.KRP * rtb_Sum4;

  /* Gain: '<S3>/Filter Coefficient' incorporates:
   *  Gain: '<S3>/Derivative Gain'
   *  Integrator: '<S3>/Filter'
   *  Sum: '<S3>/SumD'
   */
  Controllers_B.FilterCoefficient = (Controllers_P.KRD * rtb_Sum4 -
    Controllers_X.Filter_CSTATE) * Controllers_P.N;

  /* Saturate: '<S1>/Saturation1' incorporates:
   *  Inport: '<Root>/Stick'
   */
  if (Controllers_U.Stick[1] > Controllers_P.Saturation1_UpperSat) {
    Sphi = Controllers_P.Saturation1_UpperSat;
  } else if (Controllers_U.Stick[1] < Controllers_P.Saturation1_LowerSat) {
    Sphi = Controllers_P.Saturation1_LowerSat;
  } else {
    Sphi = Controllers_U.Stick[1];
  }

  /* Sum: '<S1>/Sum1' incorporates:
   *  Gain: '<S1>/Yaw-rate2'
   *  Inport: '<Root>/IMU_Attitude'
   *  Saturate: '<S1>/Saturation1'
   */
  rtb_Sum4 = Controllers_P.pitchMax * Sphi - Controllers_U.IMU_Attitude[1];

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  Gain: '<S2>/Derivative Gain'
   *  Integrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  Controllers_B.FilterCoefficient_d = (Controllers_P.KPD * rtb_Sum4 -
    Controllers_X.Filter_CSTATE_j) * Controllers_P.N;

  /* MATLAB Function: '<S1>/To body from Earth_rates' incorporates:
   *  Inport: '<Root>/IMU_Attitude'
   */
  /* MATLAB Function 'Attitude Controller/To body from Earth_rates': '<S7>:1' */
  /* '<S7>:1:3' */
  /* '<S7>:1:4' */
  /* '<S7>:1:6' */
  Sphi = sin(Controllers_U.IMU_Attitude[0]);

  /* '<S7>:1:7' */
  Cphi = cos(Controllers_U.IMU_Attitude[0]);

  /* '<S7>:1:8' */
  /* '<S7>:1:9' */
  Ctheta = cos(Controllers_U.IMU_Attitude[1]);

  /* '<S7>:1:11' */
  /* '<S7>:1:15' */
  tmp[0] = 1.0;
  tmp[3] = 0.0;
  tmp[6] = -sin(Controllers_U.IMU_Attitude[1]);
  tmp[1] = 0.0;
  tmp[4] = Cphi;
  tmp[7] = Sphi * Ctheta;
  tmp[2] = 0.0;
  tmp[5] = -Sphi;
  tmp[8] = Cphi * Ctheta;

  /* SignalConversion: '<S7>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S2>/Proportional Gain'
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Sum: '<S2>/Sum'
   *  Sum: '<S3>/Sum'
   */
  Ctheta = rtb_ProportionalGain + Controllers_B.FilterCoefficient;
  Cphi = Controllers_P.KPP * rtb_Sum4 + Controllers_B.FilterCoefficient_d;

  /* Gain: '<S1>/Yaw-rate' incorporates:
   *  Inport: '<Root>/Stick'
   *  Saturate: '<S1>/Saturation2'
   */
  if (Controllers_U.Stick[2] > Controllers_P.Saturation2_UpperSat) {
    Sphi = Controllers_P.Saturation2_UpperSat;
  } else if (Controllers_U.Stick[2] < Controllers_P.Saturation2_LowerSat) {
    Sphi = Controllers_P.Saturation2_LowerSat;
  } else {
    Sphi = Controllers_U.Stick[2];
  }

  /* SignalConversion: '<S7>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S1>/Yaw-rate'
   *  MATLAB Function: '<S1>/To body from Earth_rates'
   *  Saturate: '<S1>/Saturation2'
   */
  Sphi *= Controllers_P.yawRateMax;

  /* MATLAB Function: '<S1>/To body from Earth_rates' */
  for (i = 0; i < 3; i++) {
    rtb_Rates_B[i] = tmp[i + 6] * Sphi + (tmp[i + 3] * Cphi + tmp[i] * Ctheta);
  }

  /* Sum: '<S1>/Sum4' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   */
  rtb_Sum4 = rtb_Rates_B[0] - Controllers_U.IMU_Rates[0];

  /* Gain: '<S4>/Filter Coefficient' incorporates:
   *  Gain: '<S4>/Derivative Gain'
   *  Integrator: '<S4>/Filter'
   *  Sum: '<S4>/SumD'
   */
  Controllers_B.FilterCoefficient_e = (Controllers_P.Kdp * rtb_Sum4 -
    Controllers_X.Filter_CSTATE_j1) * Controllers_P.N;

  /* Sum: '<S4>/Sum' incorporates:
   *  Gain: '<S4>/Proportional Gain'
   *  Integrator: '<S4>/Integrator'
   */
  rtb_ProportionalGain = (Controllers_P.Kpp * rtb_Sum4 +
    Controllers_X.Integrator_CSTATE) + Controllers_B.FilterCoefficient_e;

  /* Saturate: '<S4>/Saturate' */
  if (rtb_ProportionalGain > Controllers_P.satp) {
    Sphi = Controllers_P.satp;
  } else if (rtb_ProportionalGain < -Controllers_P.satp) {
    Sphi = -Controllers_P.satp;
  } else {
    Sphi = rtb_ProportionalGain;
  }

  /* End of Saturate: '<S4>/Saturate' */

  /* Sum: '<S1>/Sum5' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   */
  Cphi = rtb_Rates_B[1] - Controllers_U.IMU_Rates[1];

  /* Gain: '<S5>/Filter Coefficient' incorporates:
   *  Gain: '<S5>/Derivative Gain'
   *  Integrator: '<S5>/Filter'
   *  Sum: '<S5>/SumD'
   */
  Controllers_B.FilterCoefficient_p = (Controllers_P.Kdq * Cphi -
    Controllers_X.Filter_CSTATE_a) * Controllers_P.N;

  /* Sum: '<S5>/Sum' incorporates:
   *  Gain: '<S5>/Proportional Gain'
   *  Integrator: '<S5>/Integrator'
   */
  Ctheta = (Controllers_P.Kpq * Cphi + Controllers_X.Integrator_CSTATE_c) +
    Controllers_B.FilterCoefficient_p;

  /* Saturate: '<S5>/Saturate' */
  if (Ctheta > Controllers_P.satq) {
    rtb_Saturate_p = Controllers_P.satq;
  } else if (Ctheta < -Controllers_P.satq) {
    rtb_Saturate_p = -Controllers_P.satq;
  } else {
    rtb_Saturate_p = Ctheta;
  }

  /* End of Saturate: '<S5>/Saturate' */

  /* Sum: '<S1>/Sum6' incorporates:
   *  Inport: '<Root>/IMU_Rates'
   */
  rtb_Sum6 = rtb_Rates_B[2] - Controllers_U.IMU_Rates[2];

  /* Gain: '<S6>/Filter Coefficient' incorporates:
   *  Gain: '<S6>/Derivative Gain'
   *  Integrator: '<S6>/Filter'
   *  Sum: '<S6>/SumD'
   */
  Controllers_B.FilterCoefficient_n = (Controllers_P.Kdr * rtb_Sum6 -
    Controllers_X.Filter_CSTATE_c) * Controllers_P.N;

  /* Sum: '<S6>/Sum' incorporates:
   *  Gain: '<S6>/Proportional Gain'
   *  Integrator: '<S6>/Integrator'
   */
  rtb_Sum_ou = (Controllers_P.Kpr * rtb_Sum6 + Controllers_X.Integrator_CSTATE_b)
    + Controllers_B.FilterCoefficient_n;

  /* Saturate: '<S6>/Saturate' */
  if (rtb_Sum_ou > Controllers_P.satr) {
    rtb_Saturate_e = Controllers_P.satr;
  } else if (rtb_Sum_ou < -Controllers_P.satr) {
    rtb_Saturate_e = -Controllers_P.satr;
  } else {
    rtb_Saturate_e = rtb_Sum_ou;
  }

  /* End of Saturate: '<S6>/Saturate' */

  /* Outport: '<Root>/Moments' */
  Controllers_Y.Moments[0] = Sphi;
  Controllers_Y.Moments[1] = rtb_Saturate_p;
  Controllers_Y.Moments[2] = rtb_Saturate_e;

  /* Sum: '<S4>/SumI1' incorporates:
   *  Gain: '<S4>/Integral Gain'
   *  Gain: '<S4>/Kb'
   *  Sum: '<S4>/SumI2'
   */
  Controllers_B.SumI1 = (Sphi - rtb_ProportionalGain) * Controllers_P.Kbp +
    Controllers_P.Kip * rtb_Sum4;

  /* Sum: '<S5>/SumI1' incorporates:
   *  Gain: '<S5>/Integral Gain'
   *  Gain: '<S5>/Kb'
   *  Sum: '<S5>/SumI2'
   */
  Controllers_B.SumI1_m = (rtb_Saturate_p - Ctheta) * Controllers_P.Kbq +
    Controllers_P.Kiq * Cphi;

  /* Sum: '<S6>/SumI1' incorporates:
   *  Gain: '<S6>/Integral Gain'
   *  Gain: '<S6>/Kb'
   *  Sum: '<S6>/SumI2'
   */
  Controllers_B.SumI1_o = (rtb_Saturate_e - rtb_Sum_ou) * Controllers_P.Kbr +
    Controllers_P.Kir * rtb_Sum6;
  if (rtmIsMajorTimeStep((&Controllers_M))) {
    rt_ertODEUpdateContinuousStates(&(&Controllers_M)->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++(&Controllers_M)->Timing.clockTick0)) {
      ++(&Controllers_M)->Timing.clockTickH0;
    }

    (&Controllers_M)->Timing.t[0] = rtsiGetSolverStopTime(&(&Controllers_M)
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
      (&Controllers_M)->Timing.clockTick1++;
      if (!(&Controllers_M)->Timing.clockTick1) {
        (&Controllers_M)->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void ControllersModelClass::Controllers_derivatives()
{
  XDot_Controllers_T *_rtXdot;
  _rtXdot = ((XDot_Controllers_T *) (&Controllers_M)->ModelData.derivs);

  /* Derivatives for Integrator: '<S3>/Filter' */
  _rtXdot->Filter_CSTATE = Controllers_B.FilterCoefficient;

  /* Derivatives for Integrator: '<S2>/Filter' */
  _rtXdot->Filter_CSTATE_j = Controllers_B.FilterCoefficient_d;

  /* Derivatives for Integrator: '<S4>/Integrator' */
  _rtXdot->Integrator_CSTATE = Controllers_B.SumI1;

  /* Derivatives for Integrator: '<S4>/Filter' */
  _rtXdot->Filter_CSTATE_j1 = Controllers_B.FilterCoefficient_e;

  /* Derivatives for Integrator: '<S5>/Integrator' */
  _rtXdot->Integrator_CSTATE_c = Controllers_B.SumI1_m;

  /* Derivatives for Integrator: '<S5>/Filter' */
  _rtXdot->Filter_CSTATE_a = Controllers_B.FilterCoefficient_p;

  /* Derivatives for Integrator: '<S6>/Integrator' */
  _rtXdot->Integrator_CSTATE_b = Controllers_B.SumI1_o;

  /* Derivatives for Integrator: '<S6>/Filter' */
  _rtXdot->Filter_CSTATE_c = Controllers_B.FilterCoefficient_n;
}

/* Model initialize function */
void ControllersModelClass::initialize()
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)(&Controllers_M), 0,
                sizeof(RT_MODEL_Controllers_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&(&Controllers_M)->solverInfo, &(&Controllers_M)
                          ->Timing.simTimeStep);
    rtsiSetTPtr(&(&Controllers_M)->solverInfo, &rtmGetTPtr((&Controllers_M)));
    rtsiSetStepSizePtr(&(&Controllers_M)->solverInfo, &(&Controllers_M)
                       ->Timing.stepSize0);
    rtsiSetdXPtr(&(&Controllers_M)->solverInfo, &(&Controllers_M)
                 ->ModelData.derivs);
    rtsiSetContStatesPtr(&(&Controllers_M)->solverInfo, (real_T **)
                         &(&Controllers_M)->ModelData.contStates);
    rtsiSetNumContStatesPtr(&(&Controllers_M)->solverInfo, &(&Controllers_M)
      ->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&(&Controllers_M)->solverInfo, (&rtmGetErrorStatus
      ((&Controllers_M))));
    rtsiSetRTModelPtr(&(&Controllers_M)->solverInfo, (&Controllers_M));
  }

  rtsiSetSimTimeStep(&(&Controllers_M)->solverInfo, MAJOR_TIME_STEP);
  (&Controllers_M)->ModelData.intgData.y = (&Controllers_M)->ModelData.odeY;
  (&Controllers_M)->ModelData.intgData.f[0] = (&Controllers_M)->ModelData.odeF[0];
  (&Controllers_M)->ModelData.intgData.f[1] = (&Controllers_M)->ModelData.odeF[1];
  (&Controllers_M)->ModelData.contStates = ((X_Controllers_T *) &Controllers_X);
  rtsiSetSolverData(&(&Controllers_M)->solverInfo, (void *)&(&Controllers_M)
                    ->ModelData.intgData);
  rtsiSetSolverName(&(&Controllers_M)->solverInfo,"ode2");
  rtmSetTPtr((&Controllers_M), &(&Controllers_M)->Timing.tArray[0]);
  (&Controllers_M)->Timing.stepSize0 = 0.01;

  /* block I/O */
  (void) memset(((void *) &Controllers_B), 0,
                sizeof(B_Controllers_T));

  /* states (continuous) */
  {
    (void) memset((void *)&Controllers_X, 0,
                  sizeof(X_Controllers_T));
  }

  /* external inputs */
  (void) memset((void *)&Controllers_U, 0,
                sizeof(ExtU_Controllers_T));

  /* external outputs */
  (void) memset(&Controllers_Y.Moments[0], 0,
                3U*sizeof(real_T));

  /* InitializeConditions for Integrator: '<S3>/Filter' */
  Controllers_X.Filter_CSTATE = Controllers_P.Filter_IC;

  /* InitializeConditions for Integrator: '<S2>/Filter' */
  Controllers_X.Filter_CSTATE_j = Controllers_P.Filter_IC_d;

  /* InitializeConditions for Integrator: '<S4>/Integrator' */
  Controllers_X.Integrator_CSTATE = Controllers_P.Integrator_IC;

  /* InitializeConditions for Integrator: '<S4>/Filter' */
  Controllers_X.Filter_CSTATE_j1 = Controllers_P.Filter_IC_f;

  /* InitializeConditions for Integrator: '<S5>/Integrator' */
  Controllers_X.Integrator_CSTATE_c = Controllers_P.Integrator_IC_n;

  /* InitializeConditions for Integrator: '<S5>/Filter' */
  Controllers_X.Filter_CSTATE_a = Controllers_P.Filter_IC_k;

  /* InitializeConditions for Integrator: '<S6>/Integrator' */
  Controllers_X.Integrator_CSTATE_b = Controllers_P.Integrator_IC_o;

  /* InitializeConditions for Integrator: '<S6>/Filter' */
  Controllers_X.Filter_CSTATE_c = Controllers_P.Filter_IC_j;
}

/* Model terminate function */
void ControllersModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
ControllersModelClass::ControllersModelClass()
{
  static const P_Controllers_T Controllers_P_temp = {
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
    0.40514779629427244,               /* Variable: Kbp
                                        * Referenced by: '<S4>/Kb'
                                        */
    0.40514779629427244,               /* Variable: Kbq
                                        * Referenced by: '<S5>/Kb'
                                        */
    0.34985711369071804,               /* Variable: Kbr
                                        * Referenced by: '<S6>/Kb'
                                        */
    0.0499,                            /* Variable: Kdp
                                        * Referenced by: '<S4>/Derivative Gain'
                                        */
    0.0499,                            /* Variable: Kdq
                                        * Referenced by: '<S5>/Derivative Gain'
                                        */
    0.0153,                            /* Variable: Kdr
                                        * Referenced by: '<S6>/Derivative Gain'
                                        */
    0.304,                             /* Variable: Kip
                                        * Referenced by: '<S4>/Integral Gain'
                                        */
    0.304,                             /* Variable: Kiq
                                        * Referenced by: '<S5>/Integral Gain'
                                        */
    0.125,                             /* Variable: Kir
                                        * Referenced by: '<S6>/Integral Gain'
                                        */
    0.298,                             /* Variable: Kpp
                                        * Referenced by: '<S4>/Proportional Gain'
                                        */
    0.298,                             /* Variable: Kpq
                                        * Referenced by: '<S5>/Proportional Gain'
                                        */
    0.135,                             /* Variable: Kpr
                                        * Referenced by: '<S6>/Proportional Gain'
                                        */
    100.0,                             /* Variable: N
                                        * Referenced by:
                                        *   '<S2>/Filter Coefficient'
                                        *   '<S3>/Filter Coefficient'
                                        *   '<S4>/Filter Coefficient'
                                        *   '<S5>/Filter Coefficient'
                                        *   '<S6>/Filter Coefficient'
                                        */
    0.52359877559829882,               /* Variable: pitchMax
                                        * Referenced by: '<S1>/Yaw-rate2'
                                        */
    0.52359877559829882,               /* Variable: rollMax
                                        * Referenced by: '<S1>/Yaw-rate1'
                                        */
    1.5,                               /* Variable: satp
                                        * Referenced by: '<S4>/Saturate'
                                        */
    1.5,                               /* Variable: satq
                                        * Referenced by: '<S5>/Saturate'
                                        */
    1.0,                               /* Variable: satr
                                        * Referenced by: '<S6>/Saturate'
                                        */
    1.5707963267948966,                /* Variable: yawRateMax
                                        * Referenced by: '<S1>/Yaw-rate'
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
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S6>/Integrator'
                                        */
    0.0                                /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S6>/Filter'
                                        */
  };                                   /* Modifiable parameters */

  /* Initialize tunable parameters */
  Controllers_P = Controllers_P_temp;
}

/* Destructor */
ControllersModelClass::~ControllersModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_Controllers_T * ControllersModelClass::getRTM()
{
  return (&Controllers_M);
}
