// @ts-nocheck
/* eslint-disable */
import { JSDOM } from 'jsdom';

const { window } = new JSDOM(`<!DOCTYPE html><p>Hello world</p></html>`);

window = window;
document = window.document;
