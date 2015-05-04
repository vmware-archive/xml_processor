require 'tmpdir'
require_relative '../../../lib/xml_processor/processes/xslt_transformer'

module XmlProcessor
  module Processes
    describe XsltTransformer do
      matcher :have_ids do
        match do |elements|
          elements.map {|h| h.attr('id') }.none?(&:nil?)
        end

        failure_message do |elements|
          "The following elements have nil ids:\n" +
              elements.select {|h| h.attr('id').nil?}.
                  map(&:to_xhtml).join("\n")
        end
      end

      matcher :be_html do
        match do |actual|
          actual.match(/\A<!DOCTYPE html/)
        end
      end

      matcher :have_no_spaces do
        whitespace_matcher = /\s|%20/

        match do |imgs|
          imgs.map {|i| i.attr('src')}.none? {|src| src.match(whitespace_matcher)}
        end

        failure_message do |imgs|
          "The following images have spaces in their src paths:\n" +
              imgs.select {|i| i.attr('src').match(whitespace_matcher)}.
                  map(&:to_xhtml).join("\n")
        end
      end

      def debug(html)
        tmp = Pathname(File.expand_path('../../../../../tmp', __FILE__))
        tmp.mkpath
        path = tmp.join('output.html')
        File.write(path, html)
        `open #{path}`
        puts html
      end

      context "when given the DocBook template" do
        it "turns XML <note> elements into HTML <aside> elements with class 'note'" do
          expect(html.css('aside.note').text).to match('Reserve at least 2.5 Gb of hard drive space for each version of HDP that you plan to install.')
        end

        let(:output_hash) {
          processor = XsltTransformer.new(xslt_path)
          processor.call({'some_file.xml' => docbook})
        }

        let(:html) {
          Nokogiri::HTML(output_hash.fetch('some_file.html'))
        }
        let(:docbook) {
          <<-DOCBOOK
            <?xml version="1.0" encoding="UTF-8"?>
            <book xmlns="http://docbook.org/ns/docbook">
                <?rax subtitle.font.size="20px"?>
                <title>Hortonworks Data Platform </title>
                <subtitle>Cluster Planning Guide
                </subtitle>
                <info>
                    <!-- Copyright and pubdate tags are required for PDF -->
                    <copyright>
                        <year>2012-2014</year>
                        <holder>Hortonworks, Inc.</holder>
                    </copyright>
                    <productname>Hortonworks Data Platform (HDP)</productname>
                    <pubdate>2014-12-02</pubdate>
                    <!-- Valid values for legalnotice roles are as listed below:
                    For Release Notes, use role="apache2"
                    For HDP documentation, use role="cc-by-sa"
                    -->
                    <legalnotice role="cc-by-sa">
                        <annotation>
                            <remark>This work by <link xlink:href="http://hortonworks.com">Hortonworks,
                                    Inc.</link> is licensed under a <link
                                    xlink:href="http://creativecommons.org/licenses/by-sa/3.0/"> Creative
                                    Commons Attribution-ShareAlike 3.0 Unported License</link>.</remark>
                        </annotation>
                    </legalnotice>
                    <abstract>
                        <para>The Hortonworks Data Platform, powered by Apache Hadoop, is a massively scalable
                            and 100% open source platform for storing, processing and analyzing large volumes of
                            data. It is designed to deal with data from many sources and formats in a very
                            quick, easy and cost-effective manner. The Hortonworks Data Platform consists of the
                            essential set of Apache Hadoop projects including MapReduce, Hadoop Distributed File
                            System (HDFS), HCatalog, Pig, Hive, HBase, Zookeeper and Ambari. Hortonworks is the
                            major contributor of code and patches to many of these projects. These projects have
                            been integrated and tested as part of the Hortonworks Data Platform release process
                            and installation and configuration tools have also been included. </para>
                        <para> Unlike other providers of platforms built using Apache Hadoop, Hortonworks
                            contributes 100% of our code back to the Apache Software Foundation. The Hortonworks
                            Data Platform is Apache-licensed and completely open source. We sell only expert
                            technical support, <link xlink:href="http://hortonworks.com/hadoop-training/"
                                >training</link> and partner-enablement services. All of our technology is, and
                            will remain free and open source. </para>
                        <para> Please visit the <link
                                xlink:href="http://hortonworks.com/technology/hortonworksdataplatform"
                                >Hortonworks Data Platform</link> page for more information on Hortonworks
                            technology. For more information on Hortonworks services, please visit either the
                                <link xlink:href="http://hortonworks.com/support">Support</link> or <link
                                xlink:href="http://hortonworks.com/hadoop-training">Training</link> page. Feel
                            free to <link xlink:href="http://hortonworks.com/about-us/contact-us/">Contact
                                Us</link> directly to discuss your specific needs.</para>
                    </abstract>
                </info>

                <chapter xml:id="ch_hardware-recommendations"
                  xmlns="http://docbook.org/ns/docbook"
                  xmlns:xi="http://www.w3.org/2001/XInclude"
                  xmlns:xlink="http://www.w3.org/1999/xlink" version="5.0">
                <title>Hardware Recommendations For Apache Hadoop</title>

                <para>Hadoop and HBase workloads tend to vary a lot and it takes experience to correctly anticipate the amounts of storage, processing power, and inter-node communication that will be required for different kinds of jobs.</para>
                <para>This document provides insights on choosing the appropriate hardware components for an
                    optimal balance between performance and both initial as well as the recurring costs.
                    (For a brief summary of the hardware sizing recommendations, see <link linkend="conclusion">Conclusion</link>.)</para>
                <para>Hadoop is a software framework that supports large-scale distributed data analysis on commodity servers.
                    Hortonworks is a major contributor to open source initiatives (Apache Hadoop, HDFS, Pig, Hive, HBase, Zookeeper)
                    and has extensive experience managing production level Hadoop clusters. Hortonworks recommends following the
                    design principles that drive large, hyper-scale deployments. For a Hadoop or HBase cluster, it is critical to
                    accurately predict the size, type, frequency, and latency of analysis jobs to be run. When starting with Hadoop
                    or HBase, begin small and gain experience by measuring actual workloads during a pilot project. This way you
                    can easily scale the pilot environment without making any significant changes to the existing servers, software,
                    deployment strategies, and network connectivity.</para>

                <section xml:id="typical-hadoop-cluster-hardware">
                    <title>Typical Hadoop Cluster</title>
                    <para>Hadoop and HBase clusters have two types of machines:
                        <itemizedlist>
                            <listitem><para>
                                    <emphasis role="bold">Masters</emphasis> -- HDFS NameNode, YARN
                                    ResourceManager, and HBase Master.</para></listitem>
                            <listitem><para><emphasis role="bold"> Slaves</emphasis> -- HDFS DataNodes, YARN NodeManagers, and HBase
                                    RegionServers.</para>
                                    <para>The DataNodes, NodeManagers, and HBase RegionServers are
                                    co-located or co-deployed for optimal data locality.</para>
                                    <para>In addition, HBase requires the use
                                    of a separate component (ZooKeeper) to manage the HBase cluster.</para></listitem></itemizedlist></para>
                    <para>Hortonworks recommends separating master and slave nodes because:</para>
                    <itemizedlist>
                        <listitem><para>Task/application workloads on the slave nodes should be isolated from the masters.</para></listitem>
                        <listitem><para>Slaves nodes are frequently decommissioned for maintenance.</para></listitem>
                    </itemizedlist>

                    <para>For evaluation purposes, it is possible to deploy Hadoop using a single-node
                        installation (all the masters and slave processes reside on the same machine). </para>
                    <para>For a small two-node cluster, the NameNode and the ResourceManager are both on the
                        master node, with the DataNode and NodeManager on the slave node.</para>
                    <para>Clusters of three or more machines typically use a single NameNode and
                        ResourceManager with all the other nodes as slave nodes. A High-Availability (HA) cluster would
                        use a primary and secondary NameNode , and might also use a primary and secondary ResourceManager.</para>
                    <para>Typically, a medium-to -large Hadoop cluster consists of a two-level or three-level
                        architecture built with rack-mounted servers. Each rack of servers is interconnected
                        using a 1 Gigabyte Ethernet (GbE) switch. Each rack-level switch is connected to a
                        cluster-level switch (which is typically a larger port-density 10GbE switch). These
                        cluster-level switches may also interconnect with other cluster-level switches or even
                        uplink to another level of switching infrastructure.</para>
                    <note>
                      <para>Reserve at least 2.5 Gb of hard drive space for each version of HDP that you plan to install.</para>
                    </note>
                </section>
            </book>
          DOCBOOK
        }
        let(:xslt_path) { File.open(File.expand_path('../../../../lib/xml_processor/stylesheets/docbook-html5/docbook-html5.xsl', __FILE__)) }
      end
    end
  end
end
