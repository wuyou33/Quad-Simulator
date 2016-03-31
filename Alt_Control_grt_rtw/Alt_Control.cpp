/*
 * Alt_Control.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Alt_Control".
 *
 * Model version              : 1.91
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Thu Mar 31 12:51:21 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "Alt_Control.h"
#include "Alt_Control_private.h"

/*
 * This function updates continuous states using the ODE2 fixed-step
 * solver algorithm
 */
void Alt_ControlModelClass::rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
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
  int_T nXc = 2;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Alt_Control_derivatives();

  /* f1 = f(t + h, y + h*f0) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (h*f0[i]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f1);
  this->step();
  Alt_Control_derivatives();

  /* tnew = t + h
     ynew = y + (h/2)*(f0 + f1) */
  temp = 0.5*h;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + f1[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void Alt_ControlModelClass::step()
{
  real_T rtb_Sum2;
  real_T rtb_Sum;
  real_T rtb_Saturate;
  if (rtmIsMajorTimeStep((&Alt_Control_M))) {
    /* set solver stop time */
    if (!((&Alt_Control_M)->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&(&Alt_Control_M)->solverInfo, (((&Alt_Control_M)
        ->Timing.clockTickH0 + 1) * (&Alt_Control_M)->Timing.stepSize0 *
        4294967296.0));
    } else {
      rtsiSetSolverStopTime(&(&Alt_Control_M)->solverInfo, (((&Alt_Control_M)
        ->Timing.clockTick0 + 1) * (&Alt_Control_M)->Timing.stepSize0 +
        (&Alt_Control_M)->Timing.clockTickH0 * (&Alt_Control_M)
        ->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep((&Alt_Control_M))) {
    (&Alt_Control_M)->Timing.t[0] = rtsiGetT(&(&Alt_Control_M)->solverInfo);
  }

  /* Sum: '<S1>/Sum2' incorporates:
   *  Inport: '<Root>/Altitude_ref'
   *  Inport: '<Root>/Proxy'
   */
  rtb_Sum2 = Alt_Control_U.Altitude_ref - Alt_Control_U.Proxy;

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  Gain: '<S2>/Derivative Gain'
   *  Integrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  Alt_Control_B.FilterCoefficient = (Alt_Control_P.KaD * rtb_Sum2 -
    Alt_Control_X.Filter_CSTATE) * Alt_Control_P.KaN;

  /* Sum: '<S2>/Sum' incorporates:
   *  Gain: '<S2>/Proportional Gain'
   *  Integrator: '<S2>/Integrator'
   */
  rtb_Sum = (Alt_Control_P.KaP * rtb_Sum2 + Alt_Control_X.Integrator_CSTATE) +
    Alt_Control_B.FilterCoefficient;

  /* Saturate: '<S2>/Saturate' */
  if (rtb_Sum > Alt_Control_P.sata) {
    rtb_Saturate = Alt_Control_P.sata;
  } else if (rtb_Sum < -Alt_Control_P.sata) {
    rtb_Saturate = -Alt_Control_P.sata;
  } else {
    rtb_Saturate = rtb_Sum;
  }

  /* End of Saturate: '<S2>/Saturate' */

  /* Outport: '<Root>/dT' */
  Alt_Control_Y.dT = rtb_Saturate;

  /* Sum: '<S2>/SumI1' incorporates:
   *  Gain: '<S2>/Integral Gain'
   *  Gain: '<S2>/Kb'
   *  Sum: '<S2>/SumI2'
   */
  Alt_Control_B.SumI1 = (rtb_Saturate - rtb_Sum) * Alt_Control_P.Kba +
    Alt_Control_P.KaI * rtb_Sum2;
  if (rtmIsMajorTimeStep((&Alt_Control_M))) {
    rt_ertODEUpdateContinuousStates(&(&Alt_Control_M)->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++(&Alt_Control_M)->Timing.clockTick0)) {
      ++(&Alt_Control_M)->Timing.clockTickH0;
    }

    (&Alt_Control_M)->Timing.t[0] = rtsiGetSolverStopTime(&(&Alt_Control_M)
      ->solverInfo);

    {
      /* Update absolute timer for sample time: [0.05s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 0.05, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      (&Alt_Control_M)->Timing.clockTick1++;
      if (!(&Alt_Control_M)->Timing.clockTick1) {
        (&Alt_Control_M)->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void Alt_ControlModelClass::Alt_Control_derivatives()
{
  XDot_Alt_Control_T *_rtXdot;
  _rtXdot = ((XDot_Alt_Control_T *) (&Alt_Control_M)->ModelData.derivs);

  /* Derivatives for Integrator: '<S2>/Integrator' */
  _rtXdot->Integrator_CSTATE = Alt_Control_B.SumI1;

  /* Derivatives for Integrator: '<S2>/Filter' */
  _rtXdot->Filter_CSTATE = Alt_Control_B.FilterCoefficient;
}

/* Model initialize function */
void Alt_ControlModelClass::initialize()
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)(&Alt_Control_M), 0,
                sizeof(RT_MODEL_Alt_Control_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&(&Alt_Control_M)->solverInfo, &(&Alt_Control_M)
                          ->Timing.simTimeStep);
    rtsiSetTPtr(&(&Alt_Control_M)->solverInfo, &rtmGetTPtr((&Alt_Control_M)));
    rtsiSetStepSizePtr(&(&Alt_Control_M)->solverInfo, &(&Alt_Control_M)
                       ->Timing.stepSize0);
    rtsiSetdXPtr(&(&Alt_Control_M)->solverInfo, &(&Alt_Control_M)
                 ->ModelData.derivs);
    rtsiSetContStatesPtr(&(&Alt_Control_M)->solverInfo, (real_T **)
                         &(&Alt_Control_M)->ModelData.contStates);
    rtsiSetNumContStatesPtr(&(&Alt_Control_M)->solverInfo, &(&Alt_Control_M)
      ->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&(&Alt_Control_M)->solverInfo, (&rtmGetErrorStatus
      ((&Alt_Control_M))));
    rtsiSetRTModelPtr(&(&Alt_Control_M)->solverInfo, (&Alt_Control_M));
  }

  rtsiSetSimTimeStep(&(&Alt_Control_M)->solverInfo, MAJOR_TIME_STEP);
  (&Alt_Control_M)->ModelData.intgData.y = (&Alt_Control_M)->ModelData.odeY;
  (&Alt_Control_M)->ModelData.intgData.f[0] = (&Alt_Control_M)->ModelData.odeF[0];
  (&Alt_Control_M)->ModelData.intgData.f[1] = (&Alt_Control_M)->ModelData.odeF[1];
  (&Alt_Control_M)->ModelData.contStates = ((X_Alt_Control_T *) &Alt_Control_X);
  rtsiSetSolverData(&(&Alt_Control_M)->solverInfo, (void *)&(&Alt_Control_M)
                    ->ModelData.intgData);
  rtsiSetSolverName(&(&Alt_Control_M)->solverInfo,"ode2");
  rtmSetTPtr((&Alt_Control_M), &(&Alt_Control_M)->Timing.tArray[0]);
  (&Alt_Control_M)->Timing.stepSize0 = 0.05;

  /* block I/O */
  (void) memset(((void *) &Alt_Control_B), 0,
                sizeof(B_Alt_Control_T));

  /* states (continuous) */
  {
    (void) memset((void *)&Alt_Control_X, 0,
                  sizeof(X_Alt_Control_T));
  }

  /* external inputs */
  (void) memset((void *)&Alt_Control_U, 0,
                sizeof(ExtU_Alt_Control_T));

  /* external outputs */
  Alt_Control_Y.dT = 0.0;

  /* InitializeConditions for Integrator: '<S2>/Integrator' */
  Alt_Control_X.Integrator_CSTATE = Alt_Control_P.Integrator_IC;

  /* InitializeConditions for Integrator: '<S2>/Filter' */
  Alt_Control_X.Filter_CSTATE = Alt_Control_P.Filter_IC;
}

/* Model terminate function */
void Alt_ControlModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
Alt_ControlModelClass::Alt_ControlModelClass()
{
  static const P_Alt_Control_T Alt_Control_P_temp = {
    2.34,                              /* Variable: KaD
                                        * Referenced by: '<S2>/Derivative Gain'
                                        */
    0.37,                              /* Variable: KaI
                                        * Referenced by: '<S2>/Integral Gain'
                                        */
    8.0,                               /* Variable: KaN
                                        * Referenced by: '<S2>/Filter Coefficient'
                                        */
    1.8748,                            /* Variable: KaP
                                        * Referenced by: '<S2>/Proportional Gain'
                                        */
    0.0,                               /* Variable: Kba
                                        * Referenced by: '<S2>/Kb'
                                        */
    5.0,                               /* Variable: sata
                                        * Referenced by: '<S2>/Saturate'
                                        */
    0.0,                               /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S2>/Integrator'
                                        */
    0.0                                /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
  };                                   /* Modifiable parameters */

  /* Initialize tunable parameters */
  Alt_Control_P = Alt_Control_P_temp;
}

/* Destructor */
Alt_ControlModelClass::~Alt_ControlModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_Alt_Control_T * Alt_ControlModelClass::getRTM()
{
  return (&Alt_Control_M);
}
