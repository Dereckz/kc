using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using wcfKioskoCli;
using System.IO;
using Telerik.Web.UI;

public partial class imss_documentos : System.Web.UI.Page
{
    string FileNames = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["objusuario"] == null)
        {
            Session.Abandon();
            Response.Cookies.Add(new HttpCookie("ASP.NET_SessionId", ""));
            Response.Redirect("../default.aspx");
        }

        if (!IsPostBack)
        {
          


        }
    }

    

    protected void cmdbuscar_Click(object sender, EventArgs e)
    {
        lblmensaje.Text = "";

        cargar_grid();
    }

    private void cargar_grid()
    {
        wcfKioskoCli.IsvcKioskoCliClient Manejador = new IsvcKioskoCliClient();
        DataSet dsDocumentos = new DataSet();
        dsDocumentos.Tables.Add("Tabla");
        dsDocumentos.Tables[0].Columns.Add("iIdArchivosAlta");
        dsDocumentos.Tables[0].Columns.Add("cNombreArchivo");
        dsDocumentos.Tables[0].Columns.Add("mes");
        dsDocumentos.Tables[0].Columns.Add("fecha");
        dsDocumentos.Tables[0].Columns.Add("anio");


        try
        {
            Tabla tbDocumentos = Manejador.getEjecutaStoredProcedure1("getArchivosAltaListar", Session["idusuario"].ToString() + "|" + (cbomes.SelectedIndex + 1) + "|" + cboanio.Text);
            if (tbDocumentos != null)
            {
                DataTable dtDocumentos = clFunciones.convertToDatatable(tbDocumentos);
                for (int x = 0; x < dtDocumentos.Rows.Count; x++)
                {
                    dsDocumentos.Tables[0].Rows.Add(dtDocumentos.Rows[x]["iIdArchivosAlta"],
                                                    dtDocumentos.Rows[x]["cNombreArchivo"],
                                                    dtDocumentos.Rows[x]["mes"],
                        // DateTime.Parse(dtDocumentos.Rows[x]["fecha"].ToString().Remove(18)),//).ToShortDateString(),
                                                    DateTime.Parse(dtDocumentos.Rows[x]["fecha"].ToString().Remove(18)).ToShortDateString(),
                                                    dtDocumentos.Rows[x]["anio"]);

                }

                Session["dsDocs"] = dsDocumentos;
                dtgnominas.DataSource = dsDocumentos;

            }
            else
            {
                Session["dsDocs"] = null;
                dtgnominas.DataSource = null;
                lblmensaje.Text = "Sin Documentos";

            }
            dtgnominas.DataBind();

        }
        catch (Exception EX)
        {
            clFunciones.JQMensaje(this, EX.Message.Replace("'", ""), TipoMensaje.Error);
        }

    }

    protected void dtgnominas_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {

            if (e.CommandName == "Select")
            {
                int id = Convert.ToInt32(e.CommandArgument);


                //DateTime fecha = DateTime.Parse(((Label)dtgnominas.Rows[id].FindControl("lblfecha")).Text);
                string archivo = ((Label)dtgnominas.Rows[id].FindControl("nombrearchivo")).Text;

                Session["ruta"] = "anexos/" + archivo;
                String path = Server.MapPath("../anexos") + "\\" + archivo;
                String path2 = "../anexos/" + archivo;



                Session["archivo"] = archivo;

                System.IO.FileInfo toDownload = new System.IO.FileInfo(path);
                if (toDownload.Exists)
                {
                    Response.Redirect("../descarga.aspx", false);
                    //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "popup", "window.open('" + path2  + "','_blank')", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, typeof(string), "alert", "alert('No se encuentra el archivo ');", true);

                }

            }


        }
        catch (Exception EX)
        {
            clFunciones.JQMensaje(this, EX.Message.Replace("'", ""), TipoMensaje.Error);
        }
    }



    protected void dtgnominas_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        dtgnominas.DataSource = (DataSet)Session["dsPagos"];
        dtgnominas.PageIndex = e.NewPageIndex;
        dtgnominas.DataBind();
    }

    protected void dtgnominas_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void onButtonClick(object sender, EventArgs e)
    {
        try
        {
            lblmensaje.Text = "";

            wcfKioskoCli.IsvcKioskoCliClient Manejador = new IsvcKioskoCliClient();
            if (subiranexos())
            {
                Tabla tbSubirDoc = Manejador.getEjecutaStoredProcedure1("setArchivosAltaInsertar", 1 + "|" + FileNames + "|" + Session["idusuario"].ToString() + "|" + 99 + "|" + cboanio.Text + "|" + (cbomes.SelectedIndex + 1) + "|" + DateTime.Now.ToShortDateString() + "|" + 1);

                if (tbSubirDoc != null)
                {
                    Response.Redirect("files.aspx");

                }

            }
        }
        catch (Exception ex)
        {

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, typeof(string), "alertScript", "error('" + ex.Message + "');", true);

        }
    }

    private Boolean subiranexos()
    {
        Boolean saveX = false;

        RadUpload1.MaxFileSize = 10240000;

        try
        {
          


            //
            //if (RadUpload1.InitialFileInputsCount > 0)
            if (RadUpload1.UploadedFiles.Count > 0)
            {
                string targetFolder = Server.MapPath("~/anexos");

                string randomtext = Generador.ClaveAccesoUsuario(15);
                int i = 0;
                foreach (UploadedFile validFile in RadUpload1.UploadedFiles)
                {
                    if (validFile.ContentLength > RadUpload1.MaxFileSize)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, typeof(string), "alertScript", "error('El tamaño de algun archivo es muy grande, no debe superar 10MB.');", true);
                        return false;
                    }
                    i++;
                    FileNames += randomtext + "_" + i + "_" + validFile.GetName() + " | ";
                    //validFile.SaveAs(Path.Combine(targetFolder, validFile.GetName()), true);
                    validFile.SaveAs(Path.Combine(targetFolder, randomtext + "_" + i.ToString() + "_" + validFile.GetName()), true);
                }
                FileNames = FileNames.Trim();
                FileNames = FileNames.Substring(0, FileNames.Length - 1);
                saveX = true;

            }
            else
            {
                // saveX = true;
                saveX = false;
            }
        }
        catch (Exception ex)
        {
            saveX = false;
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, typeof(string), "alertScript", "error('" + ex.Message + "');", true);
        }

        return saveX;



    }
}